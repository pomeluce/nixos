{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.mo.system.mihomo {
    services.mihomo = {
      enable = true;
      tunMode = true;
      webui = pkgs.metacubexd;
      configFile = config.sops.templates."mihomo.yaml".path;
    };

    sops.templates."mihomo.yaml".content = ''
      proxy-providers:
        fc:
          type: http
          interval: 36000
          url: "${config.sops.placeholder.MIHOMO_PROVIDER}"
          path: ./proxy_provider/fc.yaml
          health-check:
            enable: true
            url: https://cp.cloudflare.com
            interval: 300
            timeout: 1000
            tolerance: 100
          override:
            udp: true

      rule-providers:
        # anti-AD, can remove if had mistake
        # https://github.com/privacy-protection-tools/anti-AD
        anti-AD:
          type: http
          behavior: domain
          format: yaml
          path: ./rule_provider/anti-AD.yaml
          url: "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-clash.yaml?"
          interval: 6000
        anti-AD-white:
          type: http
          behavior: domain
          format: yaml
          path: ./rule_provider/anti-AD-white.yaml
          url: "https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-for-clash.yaml?"
          interval: 6000

      mode: rule
      ipv6: true
      log-level: info
      allow-lan: true
      mixed-port: 7890
      unified-delay: true
      external-controller: :9090
      external-ui: ui

      geodata-mode: true
      geox-url:
        geoip: "https://hub.gitmirror.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat"
        geosite: "https://hub.gitmirror.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"
        mmdb: "https://hub.gitmirror.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb"

      # default: strict
      find-process-mode: strict

      # set it to bigger number to reduce the power consumption issue on mobile devices
      # https://github.com/vernesong/OpenClash/issues/2614
      keep-alive-interval: 1800

      # 全局客户端指纹
      global-client-fingerprint: random # 随机指纹

      # 缓存
      profile:
        store-selected: true
        store-fake-ip: true

      # 域名嗅探
      sniffer:
        enable: true
        sniff:
          TLS:
            ports: [443, 8443]
          HTTP:
            ports: [80, 8080-8880]
            override-destination: true

      tun:
        enable: true
        stack: mixed # 'gvisor' 'system' 'mixted'
        dns-hijack:
          - "any:53"
          - "tcp://any:53"
        auto-route: true
        auto-redirect: true
        auto-detect-interface: true
        strict-route: true
        mtu: 1500

      dns:
        enable: true
        ipv6: true
        respect-rules: true
        enhanced-mode: fake-ip
        fake-ip-filter:
          - "*"
          - "+.lan"
          - "+.local"
          - "+.market.xiaomi.com"
        nameserver:
          - 114.114.114.114
          - 8.8.8.8
          - https://doh.pub/dns-query
          - https://dns.alidns.com/dns-query
          - 'tls://114.114.114.114#dns'
          - 'tls://8.8.4.4#dns'
          - 'tls://1.0.0.1#dns'
          - 'tls://[2001:4860:4860::8844]#dns'
          - 'tls://[2606:4700:4700::1001]#dns'
        proxy-server-nameserver:
          - https://doh.pub/dns-query
        nameserver-policy:
          "geosite:cn,private":
            - https://doh.pub/dns-query
            - https://dns.alidns.com/dns-query
          "geosite:geolocation-!cn":
            - "https://dns.cloudflare.com/dns-query"
            - "https://dns.google/dns-query"

      proxies:
        # - name: "WARP"
        #   type: wireguard
        #   server: engage.cloudflareclient.com
        #   port: 2408
        #   ip: "172.16.0.2/32"
        #   ipv6: "2606::1/128"        # 自行替换
        #   private-key: "private-key" # 自行替换
        #   public-key: "public-key"   # 自行替换
        #   udp: true
        #   reserved: "abba"           # 自行替换
        #   mtu: 1280
        #   dialer-proxy: "WARP前置"
        #   remote-dns-resolve: true
        #   dns:
        #     - https://dns.cloudflare.com/dns-query

      proxy-groups:
        # 使用 WARP 的用户需要手动在下方的 proxies 字段内添加 WARP
        # 例如 [WARP, all, Proxies, hongkong, taiwan, japan, singapore, USA, Region, DIRECT],
        - name: Proxies
          type: select
          use:
          - fc
          tolerance: 2
        - name: Manual
          type: select
          proxies:
          - all
          - Proxies
          - hongkong
          - taiwan
          - japan
          - singapore
          - USA
          - Region
          - DIRECT
        - name: DNS
          type: select
          proxies:
          - Proxies
          - Manual
          - hongkong
          - taiwan
          - japan
          - singapore
          - USA
          - Region
          - all
          - DIRECT
        # WARP 配置链式出站
        # - name: WARP前置
          # type: select
          # proxies:
          # - Proxies
          # - select
          # - hongkong
          # - taiwan
          # - japan
          # - singapore
          # - USA
          # - Region
          # - all
          # - DIRECT
          # exclude-type: "wireguard"

        - name: ADBlock
          type: select
          proxies:
          - REJECT
          - DIRECT
          - Manual

        - name: AI
          type: select
          proxies:
          - taiwan
          - singapore
          - japan
          - USA
          - france
          - germany
          - korea
          - canada
          - germany
          - ireland
          - SA
          - netherlands
          use:
          - fc
          filter: "S1|S2"
        - name: Steam
          type: url-test
          proxies:
          - Proxies
          use:
          - fc
          filter: "D1"
        - name: Netflix
          type: url-test
          proxies:
          - taiwan
          - singapore
          - japan
          - USA
          use:
          - fc
        - name: Video
          type: url-test
          proxies:
          - hongkong
          - Netflix
          - taiwan
          - singapore
          - japan
          - USA
          use:
          - fc
          filter: "US|TW|SG|JA|HK|D1"
        - name: Universal
          type: select
          proxies:
          - Proxies
          - Manual
          - hongkong
          - taiwan
          - japan
          - singapore
          - USA
          - Region
          - all
          - DIRECT
        - name: local
          type: select
          proxies:
          - DIRECT
          - Manual
          - hongkong
          - taiwan
          - japan
          - singapore
          - USA
          - korea
          - canada
          - germany
          - russia
          - ireland
          - SA
          - netherlands
          - france
          - Region
          - all
          - Proxies

        # continent
        - name: asia
          type: url-test
          use:
          - fc
          filter: "(?i)亚|asia"

        # region
        - name: hongkong
          type: url-test
          use:
          - fc
          filter: "(?i)港|hk|hongkong|hong kong"
        - name: taiwan
          type: url-test
          use:
          - fc
          filter: "(?i)台|tw|taiwan"
        - name: japan
          type: url-test
          use:
          - fc
          filter: "(?i)japan|jp|japan"
        - name: USA
          type: url-test
          use:
          - fc
          filter: "(?i)美|unitedstates|united states"
        - name: UK
          type: url-test
          use:
          - fc
          filter: "(?i)英|uk|unitedkingdom|united kingdom"
        - name: korea
          type: url-test
          use:
          - fc
          filter: "(?i)韩|korea"
        - name: canada
          type: url-test
          use:
          - fc
          filter: "(?i)加|canada"
        - name: germany
          type: url-test
          use:
          - fc
          filter: "(?i)德|ge|germany"
        - name: russia
          type: url-test
          use:
          - fc
          filter: "(?i)俄|russia"
        - name: ireland
          type: url-test
          use:
          - fc
          filter: "(?i)爱|ireland"
        - name: SA
          type: url-test
          use:
          - fc
          filter: "(?i)非|sa|south africa"
        - name: netherlands
          type: url-test
          use:
          - fc
          filter: "(?i)荷|cl|netherlands"
        - name: france
          type: url-test
          use:
          - fc
          filter: "(?i)法|france"
        - name: singapore
          type: url-test
          use:
          - fc
          filter: "(?i)(新|sg|singapore)"
        - name: Region
          type: url-test
          use:
          - fc
          filter: "(?i)^(?!.*(?:🇭🇰|🇯🇵|🇺🇸|🇸🇬|🇨🇳|港|hk|hongkong|台|tw|taiwan|日|jp|japan|新|sg|singapore|美|us|unitedstates|英|uk|unitedkingdom)).*"
        - name: all
          type: url-test
          use:
          - fc


      rules:
        - GEOSITE,private,DIRECT,no-resolve
        - GEOIP,private,DIRECT,no-resolve
        # 若需禁用 QUIC 请取消注释 QUIC 两条规则
        # 防止 YouTube 等使用 QUIC 导致速度不佳, 禁用 443 端口 UDP 流量（不包括国内）
        # - AND,(AND,(DST-PORT,443),(NETWORK,UDP)),(NOT,((GEOSITE,cn))),REJECT # quic
        - AND,((RULE-SET,anti-AD),(NOT,((RULE-SET,anti-AD-white)))),ADBlock # 感谢 Telegram @nextyahooquery 提供的建议
        # - GEOSITE,biliintl,Video
        # - GEOSITE,bilibili,Video

        - GEOSITE,openai,AI
        - GEOSITE,anthropic,AI
        - GEOSITE,x,AI
        - GEOSITE,xai,AI
        - DOMAIN-SUFFIX,claude.ai,AI
        - DOMAIN-SUFFIX,claudeusercontent.com,AI
        - DOMAIN-SUFFIX,reddit.com,singapore
        - GEOSITE,apple,Universal
        - GEOSITE,apple-cn,Universal
        - GEOSITE,ehentai,Universal
        - GEOSITE,github,Universal
        - GEOSITE,twitter,Universal
        - GEOSITE,youtube,Universal
        - GEOSITE,google,Universal
        - GEOSITE,google-cn,Universal # Google CN 不走代理会导致hongkong等地区节点 Play Store 异常
        - GEOSITE,telegram,Universal
        - GEOSITE,netflix,Netflix
        - GEOSITE,bahamut,Universal
        - GEOSITE,spotify,Universal
        - GEOSITE,pixiv,Universal
        - GEOSITE,steam@cn,DIRECT
        - GEOSITE,steam,Steam
        - GEOSITE,onedrive,Universal
        - GEOSITE,microsoft,Universal
        - GEOSITE,geolocation-!cn,Universal
        # - AND,(AND,(DST-PORT,443),(NETWORK,UDP)),(NOT,((GEOIP,CN))),REJECT # quic
        - GEOIP,google,Universal
        - GEOIP,netflix,Netflix
        - GEOIP,telegram,Universal
        - GEOIP,twitter,Universal
        - GEOSITE,CN,local
        - GEOIP,CN,local
        - MATCH,Universal
    '';
  };
}
