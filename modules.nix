{lib, config, ...}: let
  cfg = config.zpoolprops;
  types = lib.types;
in {
  options.zpoolprops = {
    altroot = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
    };
    ashift = lib.mkOption {
        type = types.int;
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

  config.zpoolprops = {
    output = let
      cleanCfg = lib.filterAttrs (name: value: value != null) (removeAttrs cfg [ "output" ]);
      stringCfg = lib.mapAttrs (name: value: builtins.toString value) cleanCfg;
      setCfg = lib.mapAttrsToList (name: value: name + "=" + value) stringCfg;
    in
      lib.concatMapStrings (x: "    -o " + x + " \\\n") setCfg;
  };
}
