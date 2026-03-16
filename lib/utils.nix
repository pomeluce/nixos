{
  lib ? import <nixpkgs/lib>,
}:
let
  stripTrailingZeros =
    str:
    let
      __rec__ =
        s:
        let
          len = builtins.stringLength s;
        in
        if len == 0 then
          s
        else
          let
            last = builtins.substring (len - 1) 1 s;
          in
          if last == "0" then
            __rec__ (builtins.substring 0 (len - 1) s)
          else if last == "." then
            builtins.substring 0 (len - 1) s
          else
            s;
    in
    __rec__ str;
in
{
  # 将浮点数转成字符串并清理尾部零
  floatToString =
    x:
    let
      s = toString x;
      isSci = builtins.match ".*[eE].*" s != null;
      hasDot = builtins.match ".*\\..*" s != null;
    in
    if isSci || !hasDot then s else stripTrailingZeros s;

  # 简化 mkMerge 使用
  mkIfMerge = condition: configs: lib.mkIf condition (lib.mkMerge configs);

  # 带默认值的 enable option
  mkEnableOptionWithDefault =
    default: description:
    lib.mkOption {
      type = lib.types.bool;
      default = default;
      description = description;
    };

  # 合并多个 attr set
  mergeAttrs = lib.foldl' (acc: x: acc // x) { };

  # 条件合并
  optionalAttrs = condition: attrs: if condition then attrs else { };
}
