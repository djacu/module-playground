{
  lib,
  config,
  ...
}: let
  cfg_zpoolprops = config.zpoolprops;
  cfg_zfsprops = config.zfsprops;
  types = lib.types;
in {
  options.zpoolprops = {
    altroot = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
    };
    ashift = lib.mkOption {
      type = types.either (types.enum [0]) (types.ints.between 9 16);
      default = 0;
    };
    autoexpand = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };
    autoreplace = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };
    autotrim = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };
    bootfs = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    cachefile = lib.mkOption {
      type = types.either types.path types.string;
      default = "none";
    };
    compatibility = lib.mkOption {
      type = types.either (types.enum ["off" "legacy"]) types.path;
      default = "off";
    };
    delegation = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "on";
    };
    failmode = lib.mkOption {
      type = types.enum ["wait" "continue" "panic"];
      default = "wait";
    };

    listsnapshots = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };
    multihost = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };

    output = lib.mkOption {
      type = types.str;
      internal = true;
    };
  };

  options.zfsprops = {
    aclmode = lib.mkOption {
      type = types.enum ["discard" "groupmask" "passthrough" "restricted"];
      default = "discard";
    };
    acltype = lib.mkOption {
      type = types.enum ["off" "noacl" "nfsv4" "posix" "posixacl"];
      default = "off";
    };
    atime = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "on";
    };
    canmount = lib.mkOption {
      type = types.enum ["on" "off" "noauto"];
      default = "off";
    };
    checksum = lib.mkOption {
      type = types.enum [
        "on"
        "off"
        "fletcher2"
        "fletcher4"
        "sha256"
        "noparity"
        "sha512"
        "skein"
        "edonr"
        "blake3"
      ];
      default = "on";
    };
    compression = let
      gzip-n = lib.range 1 9;
      zstd-n = lib.range 1 19;
      zstd-fast-n = lib.unique (lib.flatten (builtins.map (x: builtins.map (y: x * y) (lib.range 1 10)) [1 10 100]));
    in
      lib.mkOption {
        type = types.enum (lib.flatten [
          "on"
          "off"
          "gzip"
          (builtins.map (x: "gzip-${builtins.toString x}") gzip-n)
          "lz4"
          "lzjb"
          "zle"
          "zstd"
          (builtins.map (x: "zstd-${builtins.toString x}") zstd-n)
          "zstd-fast"
          (builtins.map (x: "zstd-fast-${builtins.toString x}") zstd-fast-n)
        ]);
        default = "on";
      };
    devices = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "on";
    };
    dedup = lib.mkOption {
      type = types.enum [
        "off"
        "on"
        "verify"
        "sha256"
        "sha256,verify"
        "sha512"
        "sha512,verify"
        "skein"
        "skein,verify"
        "edonr,verify"
        "blake3"
        "blake3,verify"
      ];
      default = "off";
    };
    dnodesize = lib.mkOption {
      type = types.enum [
        "legacy"
        "auto"
        "1k"
        "2k"
        "4k"
        "8k"
        "16k"
      ];
      default = "legacy";
    };
    encryption = lib.mkOption {
      type = types.enum [
        "off"
        "on"
        "aes-128-ccm"
        "aes-192-ccm"
        "aes-256-ccm"
        "aes-128-gcm"
        "aes-192-gcm"
        "aes-256-gcm"
      ];
      default = "off";
    };
    keyformat = lib.mkOption {
      type = types.nullOr (types.either types.path types.str);
      default = null;
    };
    keylocation = lib.mkOption {
      type = types.nullOr (types.oneOf [(types.enum ["prompt"]) types.path (types.strMatching "^https?://")]);
      default = null;
    };
    pbkdf2iters = lib.mkOption {
      type = types.ints.positive;
      default = 350000;
    };
    exec = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "on";
    };

    # TODO - figure out filesystem_limit

    special_small_blocks = let
      pow = let
        pow' = base: exponent: value:
        # WARNING: It will silently overflow on values > 2**62
        # The value will become negative or zero in this case
          if exponent == 0
          then 1
          else if exponent <= 1
          then value
          else (pow' base (exponent - 1) (value * base));
      in
        base: exponent: pow' base exponent base;
    in
      lib.mkOption {
        type = types.enum ([0] ++ (builtins.map (pow 2) (lib.range 9 20)));
        default = 0;
      };
    mountpoint = lib.mkOption {
      type = types.nullOr (types.either types.path (types.enum ["none" "legacy"]));
      default = null;
    };
    nbmand = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };
    overlay = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "on";
    };
    primarycache = lib.mkOption {
      type = types.enum ["all" "none" "metadata"];
      default = "all";
    };
    quota = lib.mkOption {
      type = types.nullOr (types.either types.ints.positive (types.enum ["none"]));
      default = null;
    };
    snapshot_limit = lib.mkOption {
      type = types.nullOr (types.either types.ints.positive (types.enum ["none"]));
      default = null;
    };
    readonly = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };

    # TODO - add recordsize at some point

    redundant_metadata = lib.mkOption {
      type = types.enum ["all" "most" "some" "none"];
      default = "all";
    };

    # TODO - add refquota at some point
    # TODO - add refreservation at some point

    relatime = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "on";
    };

    # TODO - add reservation at some point

    secondarycache = lib.mkOption {
      type = types.enum ["all" "none" "metadata"];
      default = "all";
    };
    setuid = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "on";
    };

    # TODO - figure out sharesmb
    # TODO - figure out sharenfs

    logbias = lib.mkOption {
      type = types.enum ["latency" "throughput"];
      default = "latency";
    };
    snapdev = lib.mkOption {
      type = types.enum ["hidden" "visible"];
      default = "hidden";
    };
    snapdir = lib.mkOption {
      type = types.enum ["hidden" "visible"];
      default = "hidden";
    };
    sync = lib.mkOption {
      type = types.enum ["standard" "always" "disabled"];
      default = "standard";
    };

    # TODO - add volsize at some point
    # TODO - add volmode at some point
    # TODO - figure out vscan

    xattr = lib.mkOption {
      type = types.enum ["on" "off" "sa"];
      default = "on";
    };
    jailed = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };
    zoned = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };

    casesensitivity = lib.mkOption {
      type = types.enum ["sensitive" "insensitive" "mixed"];
      default = "sensitive";
    };
    normalization = lib.mkOption {
      type = types.enum ["none" "formC" "formD" "formKC" "formKD"];
      default = "none";
    };
    utf8only = lib.mkOption {
      type = types.enum ["on" "off"];
      default = "off";
    };

    prefix = lib.mkOption {
      type = types.enum ["o" "O"];
      default = "o";
      internal = true;
    };
    output = lib.mkOption {
      type = types.str;
      internal = true;
    };
  };

  config.zpoolprops = {
    output = let
      cleanCfg = lib.filterAttrs (name: value: value != null) (removeAttrs cfg_zpoolprops ["output"]);
      stringCfg = lib.mapAttrs (name: value: builtins.toString value) cleanCfg;
      setCfg = lib.mapAttrsToList (name: value: name + "=" + value) stringCfg;
    in
      lib.concatMapStrings (x: "    -o ${x} \\\n") setCfg;
  };

  config.zfsprops = {
    output = let
      cleanCfg = lib.filterAttrs (name: value: value != null) (removeAttrs cfg_zfsprops ["output" "prefix"]);
      stringCfg = lib.mapAttrs (name: value: builtins.toString value) cleanCfg;
      setCfg = lib.mapAttrsToList (name: value: name + "=" + value) stringCfg;
    in
      lib.concatMapStrings (x: "    -${cfg_zfsprops.prefix} ${x} \\\n") setCfg;
  };
}
