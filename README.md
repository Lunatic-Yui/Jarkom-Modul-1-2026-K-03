# JARKOM MODUL 1 2026 - K-03

## Member

| Nama                      | NRP        |
| ------------------------- | ---------- |
| Yovi Prayudya Rizky Ramadhani       | 5027251107 |
| Dafa Ridho Zhafif  | 5027251129 |

untuk teman saya atas nama: Dafa Ridho Zhafif tidak mengerjakan sama sekali. Saya sudah mengontak di discordnya terus meminta tolong circlenya katanya bakal di wa namun sampai saat saya selesai mengerjakan ini tidak ada wa sama sekali. Jadi saya mengerjakan semua ini sendiri

## Laporan

1. Untuk mempersiapkan pembangunan The Wired, Lain yang berperan sebagai Router membuat tiga Switch/Gateway: Switch 1 menuju dua Entitas yaitu Alice dan Mika, Switch 2 menuju Chisa, sedangkan Switch 3 menuju Knights dan Eiri. Kelima Entitas tersebut dikonfigurasi sebagai Client di GNS3. [GUNAKAN PREFIX IP MASING-MASING KELOMPOK]

Untuk mempersiapkan entitas, beberapa komponen yang dibutuhkan adalah 1 router (Lain), 3 switch dengan masing-masing switch: switch 1 - Alice dan Mika, switch 2 - Chisa, switch 3 - Knights dan Eiri. Dan untuk prefix IP kelompok saya (yaitu kelompok 3) adalah 10.65.x.x sesuai pada [spreadsheet](https://docs.google.com/spreadsheets/d/14ZBfO7AgmkQgDGQkTbGF7g_w6z106lSZ/edit?gid=451046761#gid=451046761) yang sudah diberikan. Untuk gambarnya sendiri adalah

![image](./assets/topologi.png)

2. Karena menurut Lain pada saat itu The Wired masih terisolasi dari dunia luar, konfigurasikan router Lain agar dapat tersambung langsung ke jaringan internet publik melalui NAT/DHCP pada interface eth0.

Selanjutnya adalah menghubungkan router (Lain) agar bisa diconnect ke luar saya mengacu pada modul yang sudah diberikan yaitu [modul-1](https://github.com/lab-kcks/modul-komdat-jarkom-2026/tree/main/Modul%201#272-konfigurasi-router-linux-multi-homed) dan juga github guide yaitu [assistent mas ardi putra github](https://github.com/ardhptr21/Jarkom-Modul-1-2025-K55/tree/main) pada laporannya bahwa untuk menghubungkan ke luar membutuhkan konfigurasi berupa dhcp yaitu:

```
auto eth0
iface eth0 inet dhcp
```

lalu juga perlu penambahan yaitu 

```
up sysctl -w net.ipv4.ip_forward=1
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

yang mana ketika saya membaca dari website [ini](https://sites.google.com/site/nandydandyoracle/openvswitch-ovs/configuring-virtualbox-vms-for-openvswitch-networking) dan juga dari website [unix linux - ip_forward=1](https://unix.stackexchange.com/questions/673573/what-exactly-happens-when-i-enable-net-ipv4-ip-forward-1) disitu tertulis bahwa untuk menghubungkan dengan internet (misal kita mengirim ping -c3 8.8.8.8 atau sebuah domain: ping -c3 google.com), kita harus membutuhkan `sysctl -w net.ipv4.ip_forward` menjadi 1. Kalau misal kita set ke 0 maka yang terjadi adalah ketika kita mencoba ping computer 2 maka hasil dari ping ke komputer 2 akan menerima ke komputer 1 menjadi resultnya namun kalau misal ping `google.com` hasilnya tidak akan sampai ke kita alias kita hanya bisa terhubung local ping bukan ke internetnya. Selanjutnya `up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE` (dijelaskan pada soal no 4)

3. Setelah router Lain terhubung ke internet, pastikan seluruh Entitas (Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain melalui konfigurasi routing.

Untuk ini, konfigurasi routing yang saya pakai adalah

```
auto eth0
iface eth0 inet dhcp
   up sysctl -w net.ipv4.ip_forward=1    
   up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  

auto eth1
iface eth1 inet static
   address 10.65.1.1
   netmask 255.255.255.0

auto eth2
iface eth2 inet static
   address 10.65.2.1
   netmask 255.255.255.0

auto eth3
iface eth3 inet static
   address 10.65.3.1
   netmask 255.255.255.0
```

Yang mana untuk auto ethn dengan inet static adalah untuk membuatnya dia static dengan ip address yang sudah di prefix yaitu `10.65.3.1`. Karena ada 3 router maka masing-masing router diset ke 1 misal

router 1: ip addressnya adalah 10.65.1.1 -> ini untuk konfigurasi router pertama. Begitupun selanjutnya sampai ke router 3. Selanjutnya untuk client (alice, chisa, mika, knights, dan eiri), konfigurasinya adalah seperti berikut

> semua client confignya serupa. address: 10.65.x.x, netmask sama, gateway: 10.65.x.1, up echo 'nameserver 8.8.8.8' > /etc/resolv.conf
```
auto eth0
iface eth0 inet static
    address 10.65.2.2
    netmask 255.255.255.0
    gateway 10.65.2.1
    up echo 'nameserver 8.8.8.8' > /etc/resolv.conf
```
(ini contoh chisa) dengan ip addressnya adalah 10.65.2.2. Nah prefix awalnya kan `10.65.x.x` nah x pertama adalah switch yang dipasang. Jika dalam sebuah topologi dengan jumlah switch yang dipasang adalah n maka x pertama berisi n sesuai dengan switch yang terhubung. Contoh kasusnya si Chisa, karena si Chisa dalam soal adalah router 2 maka otomatis prefix ipnya adalah 2. Nah gateway ini buat apa, gateway adalah "gerbangnya" dia menerima sebuah paket. Misal kita ping google.com, otomatis membutuhkan "gateway" agar paket informasinya diterima seperti itu. untuk `echo 'nameserver 8.8.8.8' > /etc/resolv.conf'` adalah untuk menyetting configurasi agar dia bisa terhubung ke router dan bisa mengeping `google.com`. Resultnya akan ditunjukkan soal no berikutnya

4. Lain ingin agar setiap Entitas (Client) memiliki kemandirian di The Wired. Konfigurasikan firewall/iptables (NAT Masquerade) dan DNS resolver agar setiap Client dapat terhubung ke internet secara mandiri (dapat melakukan ping ke 8.8.8.8 dan membuka domain web google.com).

Seperti penjelasan sebelumnya, firewall / iptables yang dibutuhkan adalah pada routernya yaitu `up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`. Ini ibarat kata adalah firewall. Saya mengambil informasinya dari [debian-handbook](https://debian-handbook.info/browse/id-ID/stable/sect.firewall-packet-filtering.html) dan [modul-1](https://github.com/lab-kcks/modul-komdat-jarkom-2026/tree/main/Modul%201#274-konfigurasi-source-nat-iptables-masquerade) bahwa tiap client kan memiliki ip private (yaitu 10.65.x.x) maka dengan adanya `up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE` ketika kita meneruskan paketnya keluar, ip yang private ini akan disamarkan oleh si `eth0` tersebut menuju ke internet. Hasilnya adalah seperti berikut

![image](./assets/result-no4.png)

5. Eiri tetap berupaya menanamkan kekacauan ke dalam jaringan. Untuk mengantisipasi restart tiba-tiba, pastikan seluruh konfigurasi jaringan tidak hilang saat semua node di-restart. Buat script verifikasi di /root/cek_status.sh pada router Lain yang menampilkan ringkasan interface (ip -br a) dan status tabel NAT (iptables -t nat -L -v -n) setelah reboot.

untuk scriptnya seperti berikut [cek_status.sh](./src/lain/cek_status.sh)

```sh
#!/bin/bash
echo "Status Interface (ip -br a)"
ip -br a

echo ""
echo "Status NAT Table (iptables -t nat)"
iptables -t nat -L -v -n
```

Resultnya seperti berikut

![image](./assets/sebelum.png)

ini adalah sebelum terjadi restart

![image](./assets/setelah.png)

ini adalah setelah saya merestart nodenya secara tiba-tiba

nah commandnya kan ada 2, `ip -br a` dan `iptables -t nat -L -v -n`. Nah untuk yang `iptables -t nat -L -v -n` ini saya mencoba mencari informasinya dari [medium](https://medium.com/skilluped/what-is-iptables-and-how-to-use-it-781818422e52) bahwasanya iptables itu seperti sebelumnya adalah sebuah command line utility firewall agar bisa mengontrol traffic sekaligus mengamankan paket internetnya tersebut. Nah commandnya terdiri dari beberapa macam yaitu `-t nat` untuk mentranslate dari iptables (network address translation) itu bisa sharing single public ip buat access ke internet. `-L` untuk listing, `-v` untuk verbose dan terakhir `-n` untuk numeric output. Informasinya saya baca dari [medium - iptables](https://medium.com/skilluped/what-is-iptables-and-how-to-use-it-781818422e52). dan untuk `ip -br a` ...

6. Mika mencurigai adanya anomali traffic pada segmen jaringannya. Jalankan generator traffic berikut ([link file](https://drive.google.com/drive/folders/1ZjFvWIjvAQAjE9pPthm7V_bGyaSt93lY)) pada node Mika, lalu lakukan packet sniffing menggunakan Wireshark pada interface node Mika. Terapkan display filter khusus untuk menyaring paket yang berprotokol DNS atau ICMP. Tunjukkan screenshot hasil filter beserta ringkasan paket yang lolos

Hasil screenshotnya:

![image](./assets/result-6.png)

script yang diberikan:

```sh
#!/bin/bash
# ============================================
# Traffic Generator — Protocol 7 Network
# Serial Experiments Lain — Modul 1 Jarkom 2026
# Jalankan di node MIKA untuk generate traffic DNS & ICMP
# ============================================

echo "============================================"
echo "  Protocol 7 Traffic Generator v2026"
echo "  Node: Mika Iwakura"
echo "============================================"
echo "[*] Generating DNS & ICMP traffic..."

# ICMP Traffic
ping -c 5 8.8.8.8 &
ping -c 5 1.1.1.1 &
ping -c 3 its.ac.id &

# DNS Queries
nslookup google.com 8.8.8.8 &
nslookup its.ac.id 8.8.8.8 &
nslookup github.com 1.1.1.1 &
dig @8.8.8.8 example.com A &
dig @1.1.1.1 cloudflare.com AAAA &

wait
echo "[*] Traffic generation complete."
echo "[*] Check Wireshark for captured packets."
```

7. Chisa memutuskan mendirikan FTP Server pada node miliknya dengan shared folder di /var/wired/data. Terapkan kebijakan akses: user alice (hak akses read & write), user mika (dibatasi read-only), dan user eiri (dibatasi tanpa izin akses / blacklist). Buktikan konfigurasi dengan membuat file signal_alice.txt dari user alice, dan buktikan penolakan akses saat user eiri mencoba login.

(jujur ini kalau confignya gk kesimpan, ngulang lagi dari awal :>)

Confignya yang saya pakai jadi 1 tanpa kelamaan: [config.txt](./src/config.txt)

Hasilnya seperti ini:

alice

![image](./assets/user-alice-7.png)

Eiri

![image](./assets/eiri-result-no7.png)

dan untuk mika akan diproofkan pada no 9

8. Kelompok rahasia Knights perlu mengirimkan dokumen laporan intelijen ke FTP Server Chisa. Lakukan koneksi FTP client dari node Knights ke FTP Server Chisa menggunakan akun alice. Upload file berikut ([link file](https://drive.google.com/drive/folders/1tvZpueSH9E3GWwXM6KNnM64Y5wNoIAYP)). Analisis sesi Wireshark dan sebutkan: perintah FTP untuk upload (STOR), kode status sukses server (226), dan port data TCP yang dinegosiasikan pada mode PASV.

Untuk result no 8 gambarnya sepert ini

![image](./assets/result-pcap-8.png)

Dan untuk pcapnya sendiri: [result-8.pcap](./artefak-pcap/result-8.pcapng)

nah perintah ftp untuk uploadnya adalah STOR dari section no 60 dengan response `entering passive mode`. Lalu terdapat request pada no 67 terdapat request argumentnya `knights_report.txt` dan request commandnya `STOR`. Lalu pada frame / no 71 terdapat response `FTP data` sebesar 1111 bytes. 

9. Mika mengakses dokumen Protokol Tujuh di ([link file](https://drive.google.com/drive/folders/1S3hG0dnZBTkCta4uILWwKVc6dSYYGRJ6)) dari FTP Server Chisa. Dari node Mika, unduh file tersebut menggunakan akun mika. Setelah itu, buktikan pembatasan read-only dengan mencoba mengunggah file baru dari akun mika, dan tunjukkan pesan error respon server (error 550 Permission denied) saat mika mencoba melakukan upload

Untuk proof no 7 dan 9 pada akun mika seperti ini

sebelum kita lftp pakai akun mika di node mika

![image](./assets/isi_manifesto.png)

