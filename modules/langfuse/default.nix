{ config, pkgs, ... }:
let
  webPort = 3030;
  minioPort = 9090;
  dataDir = "/var/lib/langfuse";

  commonEnv = {
    TELEMETRY_ENABLED = "false";
    CLICKHOUSE_MIGRATION_URL = "clickhouse://langfuse-clickhouse:9000";
    CLICKHOUSE_URL = "http://langfuse-clickhouse:8123";
    CLICKHOUSE_USER = "clickhouse";
    CLICKHOUSE_CLUSTER_ENABLED = "false";
    REDIS_HOST = "langfuse-redis";
    REDIS_PORT = "6379";
    LANGFUSE_S3_EVENT_UPLOAD_BUCKET = "langfuse";
    LANGFUSE_S3_EVENT_UPLOAD_REGION = "auto";
    LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT = "http://langfuse-minio:9000";
    LANGFUSE_S3_EVENT_UPLOAD_FORCE_PATH_STYLE = "true";
    LANGFUSE_S3_EVENT_UPLOAD_PREFIX = "events/";
    LANGFUSE_S3_MEDIA_UPLOAD_BUCKET = "langfuse";
    LANGFUSE_S3_MEDIA_UPLOAD_REGION = "auto";
    LANGFUSE_S3_MEDIA_UPLOAD_INTERNAL_ENDPOINT = "http://langfuse-minio:9000";
    LANGFUSE_S3_MEDIA_UPLOAD_FORCE_PATH_STYLE = "true";
    LANGFUSE_S3_MEDIA_UPLOAD_PREFIX = "media/";
  };

  containerNames = [
    "langfuse-postgres"
    "langfuse-clickhouse"
    "langfuse-minio"
    "langfuse-redis"
    "langfuse-web"
    "langfuse-worker"
  ];
in
{
  sops.secrets = {
    langfuse_nextauth_secret = { };
    langfuse_salt = { };
    langfuse_encryption_key = { };
    langfuse_postgres_password = { };
    langfuse_redis_password = { };
    langfuse_clickhouse_password = { };
    langfuse_minio_password = { };
    langfuse_admin_password = { };
    langfuse_host_address = { };
  };

  sops.templates."langfuse-env".content = ''
    NEXTAUTH_URL=http://${config.sops.placeholder.langfuse_host_address}:${toString webPort}
    DATABASE_URL=postgresql://postgres:${config.sops.placeholder.langfuse_postgres_password}@langfuse-postgres:5432/postgres
    CLICKHOUSE_PASSWORD=${config.sops.placeholder.langfuse_clickhouse_password}
    REDIS_AUTH=${config.sops.placeholder.langfuse_redis_password}
    NEXTAUTH_SECRET=${config.sops.placeholder.langfuse_nextauth_secret}
    SALT=${config.sops.placeholder.langfuse_salt}
    ENCRYPTION_KEY=${config.sops.placeholder.langfuse_encryption_key}
    LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID=minio
    LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY=${config.sops.placeholder.langfuse_minio_password}
    LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID=minio
    LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY=${config.sops.placeholder.langfuse_minio_password}
    LANGFUSE_INIT_USER_PASSWORD=${config.sops.placeholder.langfuse_admin_password}
  '';

  sops.templates."langfuse-web-env".content = ''
    LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT=http://${config.sops.placeholder.langfuse_host_address}:${toString minioPort}
  '';

  sops.templates."langfuse-postgres-env".content = ''
    POSTGRES_PASSWORD=${config.sops.placeholder.langfuse_postgres_password}
  '';

  sops.templates."langfuse-clickhouse-env".content = ''
    CLICKHOUSE_PASSWORD=${config.sops.placeholder.langfuse_clickhouse_password}
  '';

  sops.templates."langfuse-minio-env".content = ''
    MINIO_ROOT_PASSWORD=${config.sops.placeholder.langfuse_minio_password}
  '';

  sops.templates."langfuse-redis-env".content = ''
    REDIS_PASSWORD=${config.sops.placeholder.langfuse_redis_password}
  '';

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 root root -"
    "d ${dataDir}/postgres 0700 999 999 -"
    "d ${dataDir}/clickhouse 0755 101 101 -"
    "d ${dataDir}/clickhouse-logs 0755 101 101 -"
    "d ${dataDir}/minio 0755 65532 65532 -"
    "d ${dataDir}/redis 0755 999 999 -"
  ];

  systemd.services =
    builtins.listToAttrs (
      map (name: {
        name = "podman-${name}";
        value.serviceConfig.RestartSec = 5;
      }) containerNames
    )
    // {
      podman-network-langfuse = {
        description = "Create the podman network used by Langfuse";
        wantedBy = [ "multi-user.target" ];
        before = map (name: "podman-${name}.service") containerNames;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${config.virtualisation.podman.package}/bin/podman network exists langfuse \
            || ${config.virtualisation.podman.package}/bin/podman network create langfuse
        '';
      };
    };

  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        langfuse-postgres = {
          image = "docker.io/postgres:17";
          environment = {
            POSTGRES_USER = "postgres";
            POSTGRES_DB = "postgres";
            TZ = "UTC";
            PGTZ = "UTC";
          };
          environmentFiles = [ config.sops.templates."langfuse-postgres-env".path ];
          volumes = [ "${dataDir}/postgres:/var/lib/postgresql/data" ];
          networks = [ "langfuse" ];
        };

        langfuse-clickhouse = {
          image = "docker.io/clickhouse/clickhouse-server:25.12";
          user = "101:101";
          environment = {
            CLICKHOUSE_DB = "default";
            CLICKHOUSE_USER = "clickhouse";
          };
          environmentFiles = [ config.sops.templates."langfuse-clickhouse-env".path ];
          volumes = [
            "${dataDir}/clickhouse:/var/lib/clickhouse"
            "${dataDir}/clickhouse-logs:/var/log/clickhouse-server"
          ];
          networks = [ "langfuse" ];
        };

        langfuse-minio = {
          image = "cgr.dev/chainguard/minio";
          entrypoint = "sh";
          cmd = [
            "-c"
            "mkdir -p /data/langfuse && minio server --address :9000 --console-address :9001 /data"
          ];
          environment.MINIO_ROOT_USER = "minio";
          environmentFiles = [ config.sops.templates."langfuse-minio-env".path ];
          volumes = [ "${dataDir}/minio:/data" ];
          ports = [ "${toString minioPort}:9000" ];
          networks = [ "langfuse" ];
        };

        langfuse-redis = {
          image = "docker.io/redis:7";
          user = "999:999";
          entrypoint = "sh";
          cmd = [
            "-c"
            ''exec redis-server --requirepass "$REDIS_PASSWORD" --maxmemory-policy noeviction''
          ];
          environmentFiles = [ config.sops.templates."langfuse-redis-env".path ];
          volumes = [ "${dataDir}/redis:/data" ];
          networks = [ "langfuse" ];
        };

        langfuse-web = {
          image = "docker.langfuse.com/langfuse/langfuse:4";
          environment = commonEnv // {
            AUTH_DISABLE_SIGNUP = "true";
            LANGFUSE_DISABLE_SIGNUP_ONBOARDING = "true";
            LANGFUSE_INIT_ORG_ID = "local";
            LANGFUSE_INIT_ORG_NAME = "Local";
            LANGFUSE_INIT_PROJECT_ID = "default";
            LANGFUSE_INIT_PROJECT_NAME = "Default";
            LANGFUSE_INIT_USER_EMAIL = "admin@local.lan";
            LANGFUSE_INIT_USER_NAME = "admin";
          };
          environmentFiles = [
            config.sops.templates."langfuse-env".path
            config.sops.templates."langfuse-web-env".path
          ];
          ports = [ "${toString webPort}:3000" ];
          networks = [ "langfuse" ];
        };

        langfuse-worker = {
          image = "docker.langfuse.com/langfuse/langfuse-worker:4";
          environment = commonEnv // {
            LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT = "http://langfuse-minio:9000";
          };
          environmentFiles = [ config.sops.templates."langfuse-env".path ];
          networks = [ "langfuse" ];
        };
      };
    };
  };
}
