    #!/bin/bash

    date=$(date +"%Y-%m-%d")
    username=$(whoami)
    domain_name=$(hostname)
    processor_model=$(lscpu| grep "Имя модели" | cut -d ":" -f 2 | sed 's/^[[:space:]]*//')
    processor_arch=$(lscpu | grep "Architecture" | cut -d ":" -f 2 | sed 's/^[[:space:]]*//')
    processor_max_frequency=$(lscpu | grep "CPU max MHz" | cut -d ":" -f 2 | sed 's/^[[:space:]]*//')
    processor_cur_frequency=$(cat /proc/cpuinfo | grep "cpu MHz" | cut -d ":" -f 2 | sed 's/^[[:space:]]*//')
    processor_cores=$(lscpu| grep "CPU(s)" | head -n 1 | cut -d ":" -f 2 | sed 's/^[[:space:]]*//')
    processor_threads=$(lscpu| grep "Потоков на ядро" | cut -d ":" -f 2 | sed 's/^[[:space:]]*//')
    processor_load=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

    #Оперативная память:
    cache_l1=$(cat /sys/devices/system/cpu/cpu0/cache/index0/size | cut -d "K" -f 1)
    cache_l2=$(cat /sys/devices/system/cpu/cpu0/cache/index2/size | cut -d "K" -f 1)
    cache_l3=$(cat /sys/devices/system/cpu/cpu0/cache/index3/size | cut -d "K" -f 1)
    ram_total=$(cat /proc/meminfo | grep "MemTotal" | awk '{print $2}')
    ram_available=$(cat /proc/meminfo | grep "MemAvailable" | awk '{print $2}')

    #Жёсткий диск:
    disk_total=$(df -h --total | grep total | awk '{print $2}')
    disk_available=$(df -h --total | grep total | awk '{print $4}')
    num_partitions=$(df -h | grep "^/dev/" | wc -l)
    partitions=$(df -h | grep "^/dev/")
    root_mounted=$(df -h | grep " /$" | awk '{print $1}')
    root_capacity=$(df -h | grep " /$" | awk '{print $2}')
    root_available=$(df -h | grep " /$" | awk '{print $4}')
    swap_total=$(cat /proc/meminfo | grep "SwapTotal" | awk '{print $2}')
    swap_available=$(cat /proc/meminfo | grep "SwapFree" | awk '{print $2}')
    
    # Вывод информации
    echo "Дата: $date"
    echo "Имя учетной записи: $username"
    echo "Доменное имя ПК: $domain_name"
    echo "Модель процессора: $processor_model"
    echo "Максимальная тактовая частота: $processor_max_frequency MHz"
    echo "Тактовая частота текущая: $processor_cur_frequency"
    echo "Количество ядер: $processor_cores"
    echo "Количество потоков на одно ядро: $processor_threads"
    echo "Загрузка процессора: $processor_load%"
    echo "Оперативная память:"
    echo "Cache L1: $cache_l1 KB"
    echo "Cache L2: $cache_l2 KB"
    echo "Cache L3: $cache_l3 KB"
    echo "Всего: $ram_total kB"
    echo "Доступно: $ram_available kB"
    echo "Жёсткий диск:"
    echo "Всего: $disk_total"
    echo "Доступно: $disk_available"
    echo "Количество разделов: $num_partitions"
    echo "По каждому разделу общий объём и доступное свободное место: $num_partitions"
    echo "Смонтировано в корневую директорию: $root_mounted"
    echo "Место в корневой директории $root_capacity"
    echo "Используемое место в корневой директории $root_available"
    echo "SWAP всего – $swap_total kB"
    echo "SWAP доступно – $swap_available kB"
    #echo "Сетевые интерфейсы:"

    
# Сетевые интерфейсы
echo ""
echo "Сетевые интерфейсы:"
#echo "Количество сетевых интерфейсов - $(ip link show | grep "state UP" | wc -l)"
interface_count=$(ip link show | grep -E "state (UP|DOWN|UNKNOWN)" | wc -l)
echo "Количество сетевых интерфейсов - $interface_count"


# Получаем список всех сетевых интерфейсов
interfaces=$(ip -o link show | awk -F': ' '{print $2}')

# Для каждого сетевого интерфейса
for interface in $interfaces
do
  echo ""
  echo "Интерфейс: $interface"
  
  # MAC-адрес
  mac=$(ip link show $interface | awk '/ether/ {print $2}')
  echo "MAC-адрес: $mac"
  
  # IP-адрес
  ip=$(ip addr show $interface | awk '/inet / {split($2, a, "/"); print a[1]}')
  echo "IP-адрес: $ip"

  speed=$(sudo ethtool $interface | grep Speed | awk '{print $2}')
  echo "Скорость: $speed"

  #if [ $interface != "lo" ]; then
        # Выводим информацию о стандарте связи с помощью команды ethtool
      #  speed1=$(sudo ethtool $interface | grep "Speed:" | awk '{print $2}')
      #  echo "Стандарт связи для интерфейса $interface: $speed1"
   # fi

  link_mode1=$(sudo ethtool $interface | grep "Supported link modes" | awk -F': ' '{print $2}' | sed "s/^[ \t]*//")
  echo "Стандарт связи 1 : $link_mode1"
  link_mode2=$(sudo ethtool $interface | awk -F: '{print $1}' | grep "base" | tail -n 2 | sed "s/^[ \t]*//")
  echo "Стандарт связи 2 : $link_mode2"
done
