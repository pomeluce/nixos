{ pkgs, npkgs, ... }:
{
  home.packages = with pkgs; [
    inter
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    # Maple Mono NF (Ligature unhinted)
    maple-mono.NF-unhinted
    # Maple Mono NF CN (Ligature unhinted)
    maple-mono.NF-CN-unhinted
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    nerd-fonts.caskaydia-mono
    npkgs.apple-font.ttf-pingfang
    npkgs.apple-font.ttf-pingfang-relaxed
    npkgs.apple-font.ttf-pingfang-ui
    npkgs.apple-font.ttf-pingfang-emoji
    wqy_zenhei
  ];

  home.file.".config/fontconfig/fonts.conf".text = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
    <fontconfig>

    # 设置无衬线字体
     <match>
      <test name="family">
       <string>sans-serif</string>
      </test>
      <edit binding="strong" mode="prepend" name="family">
       <string>Inter</string>
       <string>PingFang SC</string>
       <string>Apple Color Emoji</string>
      </edit>
     </match>

    # 设置衬线字体
     <match>
      <test name="family">
       <string>serif</string>
      </test>
      <edit binding="strong" mode="prepend" name="family">
       <string>Noto Serif</string>
       <string>Noto Serif CJK SC</string>
       <string>Apple Color Emoji</string>
      </edit>
     </match>

    # 设置等宽字体
     <match>
      <test name="family">
       <string>monospace</string>
      </test>
      <edit binding="strong" mode="prepend" name="family">
       <string>Maple Mono NF</string>
       <string>Maple Mono NF CN</string>
       <string>Apple Color Emoji</string>
      </edit>
     </match>

    # 防止网站使用苹果的emoji来渲染正常的字体
     <match>
      <test name="family">
       <string>BlinkMacSystemFont</string>
      </test>
      <edit binding="strong" mode="prepend" name="family">
       <string>Inter</string>
       <string>PingFang SC</string>
       <string>Apple Color Emoji</string>
       <string>Maple Mono NF</string>
      </edit>
     </match>


    # 有一些网站会指定某些本地字体,如 Google 和 GitHub 会指名使用 Liberation 系列字体.
    # 而我们想让网站都用我们自己定义好的字体.如下的代码可以实现这个目标.

    <!-- 替换某些 无衬线字体 为你的自定义字体或通用族 -->
     <match target="pattern">
       <test qual="any" name="family"><string>Liberation Sans</string></test>
       <edit name="family" mode="assign" binding="same"><string>sans-serif</string></edit>
     </match>

     <match target="pattern">
        <test qual="any" name="family"><string>Noto Sans</string></test>
        <edit name="family" mode="assign" binding="same"><string>sans-serif</string></edit>
      </match>

    <!-- 替换某些 等宽字体 为你的自定义字体或通用族 -->
     <match target="pattern">
       <test qual="any" name="family"><string>Liberation Mono</string></test>
       <edit name="family" mode="assign" binding="same"><string>monospace</string></edit>
     </match>

     <match target="pattern">
       <test qual="any" name="family"><string>Noto Sans Mono</string></test>
       <edit name="family" mode="assign" binding="same"><string>monospace</string></edit>
     </match>

    <!-- 替换某些 中文字体 为你的自定义字体或通用族 -->
     <match target="pattern">
       <test qual="any" name="family"><string>Noto Sans CJK SC</string></test>
       <edit name="family" mode="assign" binding="same"><string>PingFang SC</string></edit>
     </match>

    </fontconfig>
  '';
}
