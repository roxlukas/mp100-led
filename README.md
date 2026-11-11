# mp100-led — LED mini-PC MP100 pod Linuksem

Linuksowy odpowiednik dołączonego `ledcontrol.exe` oraz monitor obciążenia.

## Protokół (odczytany z ledcontrol.exe)

| | |
|---|---|
| Interfejs | wewnętrzny USB-serial CH340 `1a86:7523`, zwykle `/dev/ttyUSB0` |
| Parametry | 10000 baud, 8N1 |
| Ramka | `FA <tryb> <jasność> <prędkość> <suma>`; suma = suma 4 bajtów `& 0xFF` |
| Jasność / prędkość | na linii 1 = max … 5 = min (narzędzie przyjmuje 1–5, gdzie 5 = max) |
| Tryby | 1 tęcza, 2 oddychanie, 3 cykl kolorów, 4 wyłączone, 5 auto |
| Wysyłanie | bajt po bajcie, ~5 ms odstępu, port otwierany na jedną ramkę |

Oryginalny program **nie ma trybu stałego koloru**. Do sprawdzenia, czy firmware
ma ukryte tryby, służy `mp100-led probe`.

## Instalacja

```sh
sudo ./install.sh            # narzędzie, reguła udev, usługa (wyłączona)
sudo ./install.sh --enable   # to samo i od razu uruchamia monitor
```

Reguła udev daje grupie `plugdev` dostęp do portu i tworzy `/dev/mp100-led`,
więc `mp100-led` działa bez sudo.

## Użycie

```sh
mp100-led set rainbow -b 5 -s 3
mp100-led set off
mp100-led status                  # port, dostęp, cpu / load / temp
mp100-led probe --from 0 --to 32  # szukanie ukrytych trybów
mp100-led raw 6 1 3               # surowe bajty tryb/jasność/prędkość
```

## Monitor obciążenia

Konfiguracja w `/etc/mp100-led.conf`: metryka (`cpu`, `load`, `temp`), progi,
histereza i stan LED dla każdego z 4 poziomów (`tryb:jasność:prędkość`).
Gdy `probe` znajdzie tryby ze stałym kolorem, wpisz ich numery do `level0`–`level3`.

```sh
sudo systemctl enable --now mp100-led
journalctl -u mp100-led -f
```
