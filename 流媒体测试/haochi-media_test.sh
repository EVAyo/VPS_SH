#!/bin/bash
shell_version="1.1.6";
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36";
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)";
Disney_Auth="grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Atoken-exchange&latitude=0&longitude=0&platform=browser&subject_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiNDAzMjU0NS0yYmE2LTRiZGMtOGFlOS04ZWI3YTY2NzBjMTIiLCJhdWQiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOnRva2VuIiwibmJmIjoxNjIyNjM3OTE2LCJpc3MiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOmRldmljZSIsImV4cCI6MjQ4NjYzNzkxNiwiaWF0IjoxNjIyNjM3OTE2LCJqdGkiOiI0ZDUzMTIxMS0zMDJmLTQyNDctOWQ0ZC1lNDQ3MTFmMzNlZjkifQ.g-QUcXNzMJ8DwC9JqZbbkYUSKkB1p4JGW77OON5IwNUcTGTNRLyVIiR8mO6HFyShovsR38HRQGVa51b15iAmXg&subject_token_type=urn%3Abamtech%3Aparams%3Aoauth%3Atoken-type%3Adevice"
Disney_Header="authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84"
Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";

clear;
rm -rf result.txt
echo -e "###############################################################"
echo -e "#  流解锁测试 StreamUnlockTest${Font_Suffix}";
echo -e "#  当前版本: ${Font_SkyBlue}v${shell_version}${Font_Suffix}";
echo -e "#  ${Font_Yellow}开源地址: https://github.com/LovelyHaochi/StreamUnlockTest${Font_Suffix}";
echo -e "###############################################################";
echo -e "#  国家代码对照表: ${Font_Yellow}http://www.loglogo.com/front/countryCode/${Font_Suffix}"
echo -e "#  测试时间: $(date)"
echo -e "###############################################################";
## 写入文件
{
    echo -e "###############################################################"
    echo -e "#  流解锁测试 StreamUnlockTest";
    echo -e "#  当前版本: v${shell_version}$";
    echo -e "#  开源地址: https://github.com/LovelyHaochi/StreamUnlockTest";
    echo -e "###############################################################";
    echo -e "#  国家代码对照表: http://www.loglogo.com/front/countryCode/$"
    echo -e "#  测试时间: $(date)"
    echo -e "###############################################################";
} >> result.txt

export LANG="en_US.UTF-8";
export LANGUAGE="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

function InstallJQ() {
    if [ -e "/etc/redhat-release" ];then
        echo -e "${Font_Green}正在安装依赖: epel-release${Font_Suffix}";
        yum install epel-release -y -q > /dev/null;
        echo -e "${Font_Green}正在安装依赖: jq${Font_Suffix}";
        yum install jq -y -q > /dev/null;
    elif [[ $(< /etc/os-release grep '^ID=') =~ ubuntu ]] || [[ $(< /etc/os-release grep '^ID=') =~ debian ]];then
        echo -e "${Font_Green}正在更新软件包列表...${Font_Suffix}";
        apt-get update -y > /dev/null;
        echo -e "${Font_Green}正在安装依赖: jq${Font_Suffix}";
        apt-get install jq -y > /dev/null;
    else
        echo -e "${Font_Red}请手动安装jq${Font_Suffix}";
        exit;
    fi
}

function InstallCurl() {
    if [ -e "/etc/redhat-release" ];then
        echo -e "${Font_Green}正在安装依赖: curl${Font_Suffix}";
        yum install curl -y > /dev/null;
    elif [[ $(< /etc/os-release grep '^ID=') =~ ubuntu ]] || [[ $(< /etc/os-release grep '^ID=') =~ debian ]];then
        echo -e "${Font_Green}正在更新软件包列表...${Font_Suffix}";
        apt-get update -y > /dev/null;
        echo -e "${Font_Green}正在安装依赖: curl${Font_Suffix}";
        apt-get install curl -y > /dev/null;
    else
        echo -e "${Font_Red}请手动安装curl${Font_Suffix}";
        exit;
    fi
}

function PharseJSON() {
    # 使用方法: PharseJSON "要解析的原JSON文本" "要解析的键值"
    # Example: PharseJSON ""Value":"123456"" "Value" [返回结果: 123456]
    echo -n "$1" | jq -r ."$2";
}

function Pastebin() {
    # txt 转换 json
    sed -i 's/\x1b\[[0-9;]*m//g' result.txt;
    sed -i '1s/^/{"content": "/' result.txt;
    echo -n '"}' >> result.txt;
    sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\r//g' result.txt;
    sed -i 's/^/n&/g' result.txt;
    sed -i ':a;N;$!ba;s/n//' result.txt;
    sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\/g' result.txt;
    sed -i "s/\t/    /g" result.txt
    # 开始请求
    local bin=$(curl -fsSL --max-time 30 -H 'Content-Type: application/json' -X POST -d @result.txt https://nekobin.com/api/documents);
    local key=$(PharseJSON "$bin" "result.key");
    echo "https://nekobin.com/$key";
}

function GameTest_Steam(){
    echo -n -e " Steam:\t\t\t\t\t->\c";
    local result=$(curl --user-agent "${UA_Browser}" -"${1}" -fsSL --max-time 30 https://store.steampowered.com/app/761830 2>&1 | grep priceCurrency | cut -d '"' -f4);
    
    if [ ! -n "$result" ]; then
        local temp_text="\r Steam:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    else
        local temp_text="\r Steam:\t\t\t\t\t${Font_Green}Yes(Currency: ${result})${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function MediaUnlockTest_ABC() {
    echo -n -e " ABC:\t\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl -"${1}" --max-time 30 -fsSL -H 'Content-Type: application/x-www-form-urlencoded' -X POST -d 'type=gt&brand=001&device=001' https://prod.gatekeeper.us-abc.symphony.edgedatg.go.com/vp2/ws/utils/2020/geo/video/geolocation.json 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
		local isAllowed=$(PharseJSON "${result}" "user.allowed");
        if [ "${isAllowed}" = "true" ]; then
			local Country=$(PharseJSON "${result}" "user.country" | tr '[:lower:]' '[:upper:]')
            local temp_text="\r ABC:\t\t\t\t\t${Font_Green}Yes(Country: ${Country})${Font_Suffix}\n";
        else
            local temp_text="\r ABC:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        local temp_text="\r ABC:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function MediaUnlockTest_DAZN() {
    echo -n -e " DAZN:\t\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl -${1} --max-time 30 -fsSL -H 'Content-Type: application/json' -X POST -d '{"LandingPageKey": "generic", "Languages": "zh-TW,zh,en-US,en","Platform": "web", "Version": "2"}' https://startup.core.indazn.com/misl/v5/Startup 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
		local isAllowed=$(PharseJSON "${result}" "Region.isAllowed");
        if [[ "${isAllowed}" == "true" ]]; then
			local Country=$(PharseJSON "${result}" "Region.Country" | tr '[:lower:]' '[:upper:]')
            local temp_text="\r DAZN:\t\t\t\t\t${Font_Green}Yes(Country: ${Country})${Font_Suffix}\n";
        else
            local temp_text="\r DAZN:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        local temp_text="\r DAZN:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function MediaUnlockTest_HBONow() {
    echo -n -e " HBO Now:\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -"${1}" -fsSL --max-time 30 --write-out "%{url_effective}\n" --output /dev/null https://play.hbonow.com/ 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
        if [ "${result}" = "https://play.hbonow.com" ] || [ "${result}" = "https://play.hbonow.com/" ]; then
            local temp_text="\r HBO Now:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n";
        elif [ "${result}" = "http://hbogeo.cust.footprint.net/hbonow/geo.html" ] || [ "${result}" = "http://geocust.hbonow.com/hbonow/geo.html" ]; then
            local temp_text="\r HBO Now:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        else
            local temp_text="\r HBO Now:\t\t\t\t${Font_Yellow}Failed${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        local temp_text="\r HBO Now:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function MediaUnlockTest_HBOMax() {
    echo -n -e " HBO Max:\t\t\t\t->\c";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 30 "https://www.hbomax.com" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        # 下载页面成功，开始解析跳转
        if [[ "${result}" == *"Not in service area"* ]]; then
            local temp_text="\r HBO Max:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n";
        else
            local temp_text="\r HBO Max:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        fi
    else
        # 下载页面失败，返回错误代码
        local temp_text="\r HBO Max:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

# 流媒体解锁测试-动画疯
function MediaUnlockTest_BahamutAnime() {
    echo -n -e " Bahamut Anime:\t\t\t\t->\c";
    local tmpresult=$(curl -"${1}" --user-agent "${UA_Browser}" --max-time 30 -fsSL 'https://ani.gamer.com.tw/ajax/token.php?adID=89422&sn=14667' 2>&1);
    if [[ "$tmpresult" == "curl"* ]]; then
        local temp_text="\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
    local result="$(PharseJSON "$tmpresult" "animeSn")";
    if [ "$result" != "null" ]; then
        resultverify="$(echo "$result" | grep -oE '[0-9]{1,}')";
        if [ "$?" = "0" ]; then
            local temp_text="\r Bahamut Anime:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n";
        else
            local temp_text="\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        local result="$(PharseJSON "$tmpresult" "error.code")";
        if [ "$result" != "null" ]; then
            resultverify="$(echo "$result" | grep -oE '[0-9]{1,}')";
            if [ "$?" = "0" ]; then
                local temp_text="\r Bahamut Anime:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
            else
                local temp_text="\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
            fi
        else
            local temp_text="\r Bahamut Anime:\t\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

# 流媒体解锁测试-哔哩哔哩大陆限定
function MediaUnlockTest_BilibiliChinaMainland() {
    echo -n -e " BiliBili China Mainland Only:\t\t->\c";
    local randsession="$(< "/dev/urandom" head -n 32 | md5sum | head -c 32)";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 30 "https://api.bilibili.com/pgc/player/web/playurl?avid=82846771&qn=0&type=&otype=json&ep_id=307247&fourk=1&fnver=0&fnval=16&session=${randsession}&module=bangumi" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        local result="$(PharseJSON "${result}" "code")";
        if [ "$?" = "0" ]; then
            if [ "${result}" = "0" ]; then
                local temp_text="\r BiliBili China Mainland Only:\t\t${Font_Green}Yes${Font_Suffix}\n";
                elif [ "${result}" = "-10403" ]; then
                local temp_text="\r BiliBili China Mainland Only:\t\t${Font_Red}No${Font_Suffix}\n";
            else
                local temp_text="\r BiliBili China Mainland Only:\t\t${Font_Red}Failed${Font_Suffix} ${Font_SkyBlue}(${result})${Font_Suffix}\n";
            fi
        else
            local temp_text="\r BiliBili China Mainland Only:\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        local temp_text="\r BiliBili China Mainland Only:\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

# 流媒体解锁测试-哔哩哔哩港澳台限定
function MediaUnlockTest_BilibiliHKMCTW() {
    echo -n -e " BiliBili Hongkong/Macau/Taiwan:\t->\c";
    local randsession="$(< /dev/urandom head -n 32 | md5sum | head -c 32)";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 30 "https://api.bilibili.com/pgc/player/web/playurl?avid=18281381&cid=29892777&qn=0&type=&otype=json&ep_id=183799&fourk=1&fnver=0&fnval=16&session=${randsession}&module=bangumi" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        local result="$(PharseJSON "${result}" "code")";
        if [ "$?" = "0" ]; then
            if [ "${result}" = "0" ]; then
                local temp_text="\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Green}Yes${Font_Suffix}\n";
                elif [ "${result}" = "-10403" ]; then
                local temp_text="\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}No${Font_Suffix}\n";
            else
                local temp_text="\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}Failed${Font_Suffix} ${Font_SkyBlue}(${result})${Font_Suffix}\n";
            fi
        else
            local temp_text="\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        local temp_text="\r BiliBili Hongkong/Macau/Taiwan:\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

# 流媒体解锁测试-哔哩哔哩台湾限定
function MediaUnlockTest_BilibiliTW() {
    echo -n -e " Bilibili Taiwan Only:\t\t\t->\c";
    local randsession="$(< /dev/urandom head -n 32 | md5sum | head -c 32)";
    # 尝试获取成功的结果
    local result=$(curl --user-agent "${UA_Browser}" -"${1}" -fsSL --max-time 30 "https://api.bilibili.com/pgc/player/web/playurl?avid=50762638&cid=100279344&qn=0&type=&otype=json&ep_id=268176&fourk=1&fnver=0&fnval=16&session=${randsession}&module=bangumi" 2>&1);
    if [[ "$result" != "curl"* ]]; then
        local result="$(PharseJSON "${result}" "code")";
        if [ "$?" = "0" ]; then
            if [ "${result}" = "0" ]; then
                local temp_text="\r Bilibili Taiwan Only:\t\t\t${Font_Green}Yes${Font_Suffix}\n";
                elif [ "${result}" = "-10403" ]; then
                local temp_text="\r Bilibili Taiwan Only:\t\t\t${Font_Red}No${Font_Suffix}\n";
            else
                local temp_text="\r Bilibili Taiwan Only:\t\t\t${Font_Red}Failed${Font_Suffix} ${Font_SkyBlue}(${result})${Font_Suffix}\n";
            fi
        else
            local temp_text="\r Bilibili Taiwan Only:\t\t\t${Font_Red}Failed (Parse Json)${Font_Suffix}\n";
        fi
    else
        local temp_text="\r Bilibili Taiwan Only:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

# 流媒体解锁测试-Abema.TV
#
function MediaUnlockTest_AbemaTV_IPTest() {
    echo -n -e " Abema.TV:\t\t\t\t->\c";
    #
    local tempresult=$(curl --user-agent "${UA_Dalvik}" -"${1}" -fsL --write-out %{http_code} --max-time 30 "https://api.abema.io/v1/ip/check?device=android" 2>&1);
    if [[ "$tempresult" == "000" ]]; then
        local temp_text="\r Abema.TV:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
	
    local result=$(curl --user-agent "${UA_Dalvik}" -"${1}" -fsL --max-time 30 "https://api.abema.io/v1/ip/check?device=android" 2>&1);
	local result=$(PharseJSON "${result}" "isoCountryCode")
	if [ -n "$result" ]; then
		if [[ "$result" == "JP" ]]
			then
				local temp_text="\r Abema.TV:\t\t\t\t${Font_Green}Yes(Region: JP)${Font_Suffix}\n"
			else
				local temp_text="\r Abema.TV:\t\t\t\t${Font_Yellow}Only overseas${Font_Suffix}\n"
		fi
	else
        local temp_text="\r Abema.TV:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
    fi
  echo -n -e "$temp_text";
  echo -n -e "$temp_text" >> result.txt;
}

function GameTest_PCRJP() {
    echo -n -e " Princess Connect Re:Dive Japan:\t->\c";
    # 测试，连续请求两次 (单独请求一次可能会返回35, 第二次开始变成0)
    local result=$(curl --user-agent "${UA_Dalvik}" -"${1}" -fsL --write-out %{http_code} --output /dev/null --max-time 30 https://api-priconne-redive.cygames.jp/);
    if [ "$result" = "000" ]; then
        local temp_text="\r Princess Connect Re:Dive Japan:\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        elif [ "$result" = "404" ]; then
        local temp_text="\r Princess Connect Re:Dive Japan:\t${Font_Green}Yes${Font_Suffix}\n";
        elif [ "$result" = "403" ]; then
        local temp_text="\r Princess Connect Re:Dive Japan:\t${Font_Red}No${Font_Suffix}\n";
    else
        local temp_text="\r Princess Connect Re:Dive Japan:\t${Font_Red}Failed (Unexpected Result: $result)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function GameTest_UMAJP() {
    echo -n -e " Pretty Derby Japan:\t\t\t->\c";
    # 测试，连续请求两次 (单独请求一次可能会返回35, 第二次开始变成0)
    local result=$(curl --user-agent "${UA_Dalvik}" -"${1}" -fsL --write-out %{http_code} --output /dev/null --max-time 30 https://api-umamusume.cygames.jp/);
    if [ "$result" = "000" ]; then
        local temp_text="\r Pretty Derby Japan:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
    elif [ "$result" = "404" ]; then
        local temp_text="\r Pretty Derby Japan:\t\t\t${Font_Green}Yes${Font_Suffix}\n"
	elif [ "$result" = "403" ]; then
        local temp_text="\r Pretty Derby Japan:\t\t\t${Font_Red}No${Font_Suffix}\n"
    else
        local temp_text="\r Pretty Derby Japan:\t\t\t${Font_Red}No${Font_Suffix}\n"
    fi
  echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function GameTest_Kancolle() {
    echo -n -e " Kancolle Japan:\t\t\t->\c";
    # 测试，连续请求两次 (单独请求一次可能会返回35, 第二次开始变成0)
    local result=$(curl --user-agent "${UA_Dalvik}" -"${1}" -fsL --write-out %{http_code} --output /dev/null --max-time 30 http://203.104.209.7/kcscontents/);
    if [ "$result" = "000" ]; then
        local temp_text="\r Kancolle Japan:\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        elif [ "$result" = "200" ]; then
        local temp_text="\r Kancolle Japan:\t\t\t${Font_Green}Yes${Font_Suffix}\n"
        elif [ "$result" = "403" ]; then
        local temp_text="\r Kancolle Japan:\t\t\t${Font_Red}No${Font_Suffix}\n"
    else
        local temp_text="\r Kancolle Japan:\t\t\t${Font_Red}Failed (Unexpected Result: $result)${Font_Suffix}\n"
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function MediaUnlockTest_BBC() {
    echo -n -e " BBC:\t\t\t\t\t->\c";
    local result=$(curl --user-agent "${UA_Browser}" -"${1}" -fsL --write-out %{http_code} --output /dev/null --max-time 30 http://ve-dash-uk.live.cf.md.bbci.co.uk/);
    if [ "${result}" = "000" ]; then
        local temp_text="\r BBC:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        elif [ "${result}" = "403" ]; then
        local temp_text="\r BBC:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        elif [ "${result}" = "404" ]; then
        local temp_text="\r BBC:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n";
    else
        local temp_text="\r BBC:\t\t\t\t\t${Font_Red}Failed (Unexpected Result: $result)${Font_Suffix}\n";
    fi
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
}

function MediaUnlockTest_Netflix() {
    echo -n -e " Netflix:\t\t\t\t->\c";
    local result=$(curl -"${1}" --user-agent "${UA_Browser}" -sSL "https://www.netflix.com/" 2>&1);
    if [ "$result" == "Not Available" ];then
        local temp_text="\r Netflix:\t\t\t\t${Font_Red}Unsupport${Font_Suffix}\n";
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
    
    if [[ "$result" == "curl"* ]];then
        local temp_text="\r Netflix:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
    
    local result=$(curl -"${1}" --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80018499" 2>&1);
    if [[ "$result" == *"page-404"* ]] || [[ "$result" == *"NSEZ-403"* ]];then
        local temp_text="\r Netflix:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
    
    local result1=$(curl -"${1}" --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70143836" 2>&1);
    local result2=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/80027042" 2>&1);
    local result3=$(curl -${1} --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70140425" 2>&1);
    local result4=$(curl -"${1}" --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70283261" 2>&1);
    local result5=$(curl -${1} --user-agent "${UA_Browser}"-sL "https://www.netflix.com/title/70143860" 2>&1);
    local result6=$(curl -"${1}" --user-agent "${UA_Browser}" -sL "https://www.netflix.com/title/70202589" 2>&1);
    
    if [[ "$result1" == *"page-404"* ]] && [[ "$result2" == *"page-404"* ]] && [[ "$result3" == *"page-404"* ]] && [[ "$result4" == *"page-404"* ]] && [[ "$result5" == *"page-404"* ]] && [[ "$result6" == *"page-404"* ]];then
        local temp_text="\r Netflix:\t\t\t\t${Font_Yellow}Only Homemade${Font_Suffix}\n";
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
    
    local region=`tr [:lower:] [:upper:] <<< $(curl -${1} --user-agent "${UA_Browser}" -fs --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)` ;
    
    if [[ ! -n "$region" ]];then
        region="US";
    fi
    local temp_text="\r Netflix:\t\t\t\t${Font_Green}Yes(Region: ${region})${Font_Suffix}\n";
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
    return;
}

function MediaUnlockTest_YouTube_Region() {
    echo -n -e " YouTube:\t\t\t\t->\c";
    local result=$(curl --user-agent "${UA_Browser}" -"${1}" -sSL "https://www.youtube.com/" 2>&1);
    
    if [[ "$result" == "curl"* ]];then
        local temp_text="\r YouTube:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n";
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
    
    local result=$(curl --user-agent "${UA_Browser}" -"${1}" -sL "https://www.youtube.com/red" | sed 's/,/\n/g' | grep "countryCode" | cut -d '"' -f4);
    if [ -n "$result" ]; then
        local temp_text="\r YouTube:\t\t\t\t${Font_Green}Yes(Region: ${result})${Font_Suffix}\n";
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
    
    local temp_text="\r YouTube:\t\t\t\t${Font_Red}No${Font_Suffix}\n";
    echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
    return;
}

function MediaUnlockTest_DisneyPlus() {
    echo -n -e " DisneyPlus:\t\t\t\t->\c";
    local result=$(curl -"${1}" --user-agent "${UA_Browser}" -sSL "https://global.edge.bamgrid.com/token" 2>&1);
    
    if [[ "$result" == "curl"* ]];then
        local temp_text="\r DisneyPlus:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        echo -n -e "$temp_text";
        echo -n -e "$temp_text" >> result.txt;
        return;
    fi
	
	local previewcheck=$(curl -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://disneyplus.com" | grep preview 2>&1);
	if [ -n "${previewcheck}" ];then
		local temp_text="\r DisneyPlus:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi	
		
    
	local result=$(curl -"${1}" -s --user-agent "${UA_Browser}" -H "Content-Type: application/x-www-form-urlencoded" -H "${Disney_Header}" -d ''${Disney_Auth}'' -X POST  "https://global.edge.bamgrid.com/token" 2>&1)
	local access_token=$(PharseJSON "${result}" "access_token")

    if [[ "$access_token" == "null" ]]; then
		local temp_text="\r DisneyPlus:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi
	
	region=$(curl -"${1}" -s https://www.disneyplus.com | grep 'region: ' | awk '{print $2}')
	if [ -n "$region" ]; then
		local temp_text="\r DisneyPlus:\t\t\t\t${Font_Green}Yes(Region: ${region})${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	else
		local website=$(curl -${1} --user-agent "${UA_Browser}" -fs --write-out '%{redirect_url}\n' --output /dev/null "https://www.disneyplus.com")
		if [[ "${website}" == "https://disneyplus.disney.co.jp/" ]]; then
			local temp_text="\r DisneyPlus:\t\t\t\t${Font_Green}Yes(Region: JP)${Font_Suffix}\n"
			echo -n -e "$temp_text";
      echo -n -e "$temp_text" >> result.txt;
			return;
		else
			#local region=`echo ${website} | cut -f4 -d '/' | tr 'a-z' 'A-Z'`
			local temp_text="\r DisneyPlus:\t\t\t\t${Font_Green}Yes(Region: Unknow)${Font_Suffix}\n"
			echo -n -e "$temp_text";
      echo -n -e "$temp_text" >> result.txt;
			return;
		fi
	fi
}

# Hulu JP
function MediaUnlockTest_HuluJP() {
    echo -n -e " Hulu Japan:\t\t\t\t->\c";
    local result=$(curl -"${1}" -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://id.hulu.jp" | grep login);
    
	if [ -n "$result" ]; then
		local temp_text="\r Hulu Japan:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
     else
		local temp_text="\r Hulu Japan:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi
	
	local temp_text="\r Hulu Japan:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
	return;

}

# MyTvSuper
function MediaUnlockTest_MyTVSuper() {
    echo -n -e " MyTVSuper:\t\t\t\t->\c";
    local result=$(curl -s -"${1}" --max-time 30 https://www.mytvsuper.com/iptest.php | grep HK);
    
	if [ -n "$result" ]; then
		local temp_text="\r MyTVSuper:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
     else
		local temp_text="\r MyTVSuper:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi
	
	local temp_text="\r MyTVSuper:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
	return;

}

# Now E
function MediaUnlockTest_NowE() {
    echo -n -e " Now E:\t\t\t\t\t->\c";
    local result=$(curl -"${1}" -k --ciphers DEFAULT@SECLEVEL=1 -s --max-time 30 -X POST -H "Content-Type: application/json" -d '{"contentId":"202105121370235","contentType":"Vod","pin":"","deviceId":"W-60b8d30a-9294-d251-617b-c12f9d0c","deviceType":"WEB"}' "https://webtvapi.nowe.com/16/1/getVodURL" 2>&1);
	local result=$(PharseJSON "${result}" "responseCode")
    
	if [[ "$result" == "SUCCESS" ]]; then
		local temp_text="\r Now E:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
    else
		local temp_text="\r Now E:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi
	
	local temp_text="\r Now E:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
	return;

}

# Viu.TV
function MediaUnlockTest_ViuTV() {
    echo -n -e " ViuTV:\t\t\t\t\t->\c";
    local result=$(curl -"${1}" -k --ciphers DEFAULT@SECLEVEL=1 -s --max-time 30 -X POST -H "Content-Type: application/json" -d '{"callerReferenceNo":"20210603233037","productId":"202009041154906","contentId":"202009041154906","contentType":"Vod","mode":"prod","PIN":"password","cookie":"3c2c4eafe3b0d644b8","deviceId":"U5f1bf2bd8ff2ee000","deviceType":"ANDROID_WEB","format":"HLS"}' "https://api.viu.now.com/p8/3/getVodURL" 2>&1);
	local result=$(PharseJSON "${result}" "responseCode")
    
	if [[ "$result" == "SUCCESS" ]]; then
		local temp_text="\r ViuTV:\t\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
    else
		local temp_text="\r ViuTV:\t\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi
	
	local temp_text="\r ViuTV:\t\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
	echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
	return;

}

# U-NEXT
function MediaUnlockTest_unext() {
    echo -n -e " U-NEXT:\t\t\t\t->\c";
    local result=$(curl -"${1}" -s --max-time 30 "https://video-api.unext.jp/api/1/player?entity%5B%5D=playlist_url&episode_code=ED00148814&title_code=SID0028118&keyonly_flg=0&play_mode=caption&bitrate_low=1500" 2>&1);
	local result=$(PharseJSON "${result}" "data.entities_data.playlist_url.result_status")
	
    if [ -n "$result" ]; then 
		if [[ "$result" == "475" ]]; then
			local temp_text="\r U-NEXT:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
			echo -n -e "$temp_text";
      echo -n -e "$temp_text" >> result.txt;
			return;
		elif [[ "$result" == "200" ]]; then
			local temp_text="\r U-NEXT:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
			echo -n -e "$temp_text";
      echo -n -e "$temp_text" >> result.txt;
			return;	
		elif [[ "$result" == "467" ]]; then
			local temp_text="\r U-NEXT:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
			echo -n -e "$temp_text";
      echo -n -e "$temp_text" >> result.txt;
			return;
		else
			local temp_text="\r U-NEXT:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
			echo -n -e "$temp_text";
      echo -n -e "$temp_text" >> result.txt;
			return;
		fi	
	else
		local temp_text="\r U-NEXT:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi

}

# Paravi
function MediaUnlockTest_Paravi() {
    echo -n -e " Paravi:\t\t\t\t->\c";
    local tmpresult=$(curl -"${1}" -s --max-time 30 -H "Content-Type: application/json" -d '{"meta_id":71885,"vuid":"3b64a775a4e38d90cc43ea4c7214702b","device_code":1,"app_id":1}' https://api.paravi.jp/api/v1/playback/auth 2>&1);
	
	if [[ "$tmpresult" == "curl"* ]];then
        	local temp_text="\r Paravi:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n"
        	echo -n -e "$temp_text";
          echo -n -e "$temp_text" >> result.txt;
        	return;
    fi
	
	checkiffaild=$(PharseJSON "${tmpresult}" "error.code");
    if [[ "$checkiffaild" == "2055" ]]; then
		local temp_text="\r Paravi:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi
	
	
	local result=$(echo "${tmpresult}" | grep 'playback_validity_end_at' 2>&1)
	
	if [ -n "${result}" ]; then
		local temp_text="\r Paravi:\t\t\t\t${Font_Green}Yes${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	else
		local temp_text="\r Paravi:\t\t\t\t${Font_Red}No${Font_Suffix}\n"
		echo -n -e "$temp_text";
    echo -n -e "$temp_text" >> result.txt;
		return;
	fi

}

function MediaUnlockTest() {
	IPInfo "${1}";
	
	#echo ""
	#echo " -- Media --";
	
	echo -e "\n -- Greater China --"
    MediaUnlockTest_BilibiliChinaMainland "${1}";
    MediaUnlockTest_BilibiliHKMCTW "${1}";
    MediaUnlockTest_BilibiliTW "${1}";
    MediaUnlockTest_BahamutAnime "${1}";
	MediaUnlockTest_MyTVSuper "${1}";
	MediaUnlockTest_NowE "${1}";
	MediaUnlockTest_ViuTV "${1}";
	
	echo -e "\n -- Japan --"
    MediaUnlockTest_AbemaTV_IPTest "${1}";
	MediaUnlockTest_Paravi "${1}";
	MediaUnlockTest_unext "${1}";
	MediaUnlockTest_HuluJP "${1}";
	GameTest_PCRJP "${1}";
	GameTest_UMAJP "${1}";
	GameTest_Kancolle "${1}";
	
	echo -e "\n -- Europe and America --"
	MediaUnlockTest_HBOMax "${1}";
	MediaUnlockTest_HBONow "${1}";
	MediaUnlockTest_ABC "${1}";
	MediaUnlockTest_BBC "${1}";
	
	echo -e "\n -- Global --"
	MediaUnlockTest_Netflix "${1}";
    MediaUnlockTest_YouTube_Region "${1}";
    MediaUnlockTest_DisneyPlus "${1}";
	MediaUnlockTest_DAZN "${1}";
	GameTest_Steam "${1}";

}

function IPInfo() {
	local ip=$(curl -fsSL http://api-ipv"${1}".ip.sb/ip 2>&1);
	local result=$(curl -fsSL http://ip-api.com/json/"${ip}" 2>&1);
	local country=$(PharseJSON "${result}" "country");
	local region=$(PharseJSON "${result}" "regionName");
	local city=$(PharseJSON "${result}" "city");
	local isp=$(PharseJSON "${result}" "isp");
	local org=$(PharseJSON "${result}" "org");

	
	echo -e -n " IP:\t\t\t\t\t->\c";
	echo -e -n "\r IP:\t\t\t\t\t${Font_Green}${ip}${Font_Suffix}\n";
	echo -e -n " Country:\t\t\t\t->\c";
	echo -e -n "\r Country:\t\t\t\t${Font_Green}${country}${Font_Suffix}\n";
	echo -e -n " Region:\t\t\t\t->\c";
	echo -e -n "\r Region:\t\t\t\t${Font_Green}${region}${Font_Suffix}\n";
	echo -e -n " City:\t\t\t\t\t->\c";
	echo -e -n "\r City:\t\t\t\t\t${Font_Green}${city}${Font_Suffix}\n";
	echo -e -n " ISP:\t\t\t\t\t->\c";
	echo -e -n "\r ISP:\t\t\t\t\t${Font_Green}${isp}${Font_Suffix}\n";
	echo -e -n " Org:\t\t\t\t\t->\c";
	echo -e -n "\r Org:\t\t\t\t\t${Font_Green}${org}${Font_Suffix}\n";

	{
  	echo -e -n "\r Country:\t\t\t\t${country}\n";
	  echo -e -n "\r Region:\t\t\t\t${region}\n";
	  echo -e -n "\r City:\t\t\t\t\t${city}\n";
	  echo -e -n "\r ISP:\t\t\t\t\t${isp}\n";
	  echo -e -n "\r Org:\t\t\t\t\t${org}\n";
	} >> result.txt
	
}

# curl 包测试
if ! curl -V > /dev/null 2>&1;then
    InstallCurl;
fi

# jq 包测试
jq -V > /dev/null 2>&1;
if ! jq -V > /dev/null 2>&1;then
    InstallJQ;
fi

# 开始 ipv4 测试
echo "";
echo "- IPV4 -";
{
  echo "";
  echo "- IPV4 -";
} >> result.txt
check4=$(ping 1.1.1.1 -c 1 2>&1);
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    MediaUnlockTest 4;
else
    echo -e "${Font_SkyBlue}当前主机不支持IPv4,跳过...${Font_Suffix}";
    echo -e "当前主机不支持IPv4,跳过..." >> result.txt;
fi

# 开始 ipv6 测试
echo ""
echo "- IPV6 -";
{
  echo "";
  echo "- IPV6 -";
} >> result.txt
check6=$(ping6 240c::6666 -c 1 2>&1);
if [[ "$check6" != *"unreachable"* ]] && [[ "$check6" != *"Unreachable"* ]];then
    MediaUnlockTest 6;
else
    echo -e "${Font_SkyBlue}当前主机不支持IPv6,跳过...${Font_Suffix}";
    echo -e "当前主机不支持IPv6,跳过..." >> result.txt;
fi

echo -n -e "\n${Font_Green}测试完成，正在生成分享链接（已去除 IP 地址）${Font_Suffix}: ";
echo -n -e "\n${Font_Green}测试完成，正在生成分享链接（已去除 IP 地址）${Font_Suffix}" >> result.txt;

# 上传
Pastebin