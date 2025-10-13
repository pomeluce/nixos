{ }:
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

  # 将任意值转成字符串并清理
in
{
  floatToString =
    x:
    let
      s = builtins.toString x;
      isSci = builtins.match ".*[eE].*" s != null;
      hasDot = builtins.match ".*\\..*" s != null;
    in
    if isSci || !hasDot then s else stripTrailingZeros s;
}
