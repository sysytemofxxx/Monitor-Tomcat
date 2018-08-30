#!/bin/sh
# 获取tomcat进程ID  /www/wdlinux/tomcat8
TomcatID=$(ps -ef |grep tomcat |grep -w 'tomcat'|grep -v 'grep'|awk '{print $2}')

# tomcat启动程序
StartTomcat=/www/wdlinux/tomcat8/bin/startup.sh
#tomcat关闭程序
StopTomcat=/www/wdlinux/tomcat8/bin/shutdown.sh

# 定义要监控的页面地址
WebUrl=http://localhost:8080

# 日志输出
TomcatMonitorLog=/root/logs/TomcatMonitor.log

#状态输出
TomcatLog=/www/web/default/15TomcatLog.html

Monitor() 
{  
  echo "[info]Monitoring tomcat...[$(date +'%F %H:%M:%S')]"
  echo "</br>"  
  if [[ $TomcatID ]];then # 这里判断TOMCAT进程是否存在  
    echo -e "[info]tomcat ProcessID is:$TomcatID\n" 
    echo "</br>" 
   # 检测是否启动成功(成功的话页面会返回状态"200")  
    TomcatServiceCode=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $WebUrl)  
    if [ $TomcatServiceCode -eq 200 ];then  
        echo "[info]http_code:$TomcatServiceCode,tomcat is normal......"
        echo "</br>"  
    else  
        echo "[error]tomcat is abnormal......http_code:$TomcatServiceCode"
        echo "</br>"  
        echo "[error]Page access error, restarting"
        echo "</br>"  
        kill -9 $TomcatID  # 杀掉原tomcat进程  
        sleep 5
	$StopTomcat
	sleep 5
       # rm -rf $TomcatCache # 清理tomcat缓存  
        $StartTomcat  
    fi  
  else  
    echo "[error]Tomcat process does not exist, restarting"
    echo "</br>"
    kill -9 $TomcatID
    sleep 5
    $StopTomcat
    sleep 5  
    echo "[info]$StartTomcat,please hold on......"
    echo "</br>"  
    #rm -rf $TomcatCache  
#    $StartTomcat
  fi  
   echo "------------------------------"
   echo "</br>"  
}
 
Monitor>>$TomcatMonitorLog
Monitor>$TomcatLog

##获取nginx进程 /www/wdlinux/nginx
#NginxID=$(ps -ef |grep nginx |grep -w 'nginx'|grep -v 'grep'|awk '{print $2}')

#nginx启动程序
#StartNginx=/www/wdlinux/nginx/sbin/nginx

#定义要监控的页面地址
#WebUrl=http://localhost:80

#日志输出
#NginxMonitorLog=/root/logs/NginxMonitor.log

#Monitor()
#{
#  echo "[info]开始监控nginx...[$(date +'%F %H:%M:%S')]"
#  if [[ $NginxID ]];then #这里判断NGINX进程是否存在
#    echo "[info]当前nginx进程ID为:$NginxID,继续检测页面..."
    #检测是否启动成功(成功的话页面会返回状态"200")
#    NginxServiceCode=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $WebUrl)
#    if [ $TomcatServiceCode -eq 200 ];then
#        echo "[info]页面返回码为$NginxServiceCode,nginx启动成功，测试页面正常......"
#   else
#       echo "[error]nginx页面出错,请注意......状态码为$NginxServiceCode,错误日志
#已输出到$GetpageInfo"
#       echo "[error]页面访问出错，开始重启nginx"
#       kill -9 $NginxID #杀掉原nginx进程
#       sleep 3
#       rm -rf $NginxCache #清理nginx缓存
#       $StartNginx
#   fi
# else
#   echo "[error]nginx进程不存在！nginx开始自动重启..."
#   echo "[info]$StartNginx,请稍后......"
   #rm -rf $NginxCache
#   $StartNginx
# fi
# echo "------------------------------"
#}
#Monitor>>$NginxMonitorLog

#获取wdcp进程ID /www/wdlinux
#WdcpID=$(ps -ef |grep wdcp |grep -w 'wdcp'|grep -v 'grep'|awk '{print $2}')

# wdcp启动程序
#StartWdcp=service wdcp start

# 定义要监控的页面地址
#WebUrl=http://localhost:8888

# 日志输出
#WdcpMonitorLog=/root/logs/WdcpMonitor.log

#Monitor()
#{
#  echo "[info]开始监控wdcp...[$(date +'%F %H:%M:%S')]"
#  if [[ $WdcpID ]];then # 这里判断WDCP进程是否存在
#    echo "[info]当前wdcp进程ID为:$WdcpID,继续检测页面..."
#    # 检测是否启动成功(成功的话页面会返回状态"200")
#    WdcpServiceCode=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $WebUrl)
#    if [ $WdcpServiceCode -eq 200 ];then
#        echo "[info]页面返回码为$WdcpServiceCode,wdcp启动成功,测试页面正常......"
#    else
#        echo "[error]wdcp页面出错,请注意......状态码为$WdcpServiceCode,错误日志已输出到$GetPageInfo"
#        echo "[error]页面访问出错,开始重启wdcp"
#        kill -9 $WdcpID  # 杀掉原wdcp进程
#        sleep 3
#        rm -rf $WdcpCache # 清理wdcp缓存
#        $StartWdcp
#    fi
#  else
#    echo "[error]wdcp进程不存在!wdcp开始自动重启..."
#    echo "[info]$StartWdcp,请稍候......"
    #rm -rf $WdcpCache
#    $StartWdcp
#  fi
#  echo "------------------------------"
#}
#Monitor>>$WdcpMonitorLog
