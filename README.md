# Generic Modul - Spring Boot REST API

Bu proje, MVC mimarisi ve SOLID prensipleri kullanılarak geliştirilmiş basit bir Spring Boot REST API uygulamasıdır.

## Teknolojiler

- Java 21
- Spring Boot 3.5.5
- Maven
- Lombok
- JUnit 5 + Mockito

## Kurulum

### Gereksinimler
- Java 21
- Maven 3.8+

### Projeyi Çalıştırma

```bash
# Projeyi klonlayın
git clone <repository-url>
cd generic-modul

# Bağımlılıkları yükleyin ve uygulamayı çalıştırın
mvn clean install
mvn spring-boot:run
```

Uygulama varsayılan olarak `http://localhost:8080` adresinde çalışacaktır.

## API Uç Noktaları

### Health Check
```bash
GET /
Content-Type: text/plain
Response: "Uygulama ayakta"
```

### Tüm Mesajları Getir
```bash
GET /api/v1/messages
Content-Type: application/json
```

**Örnek Response:**
```json
[
  {"id": 1, "text": "Merhaba"},
  {"id": 2, "text": "Dünya"},
  {"id": 3, "text": "REST"}
]
```

### Tek Mesaj Getir
```bash
GET /api/v1/messages/{id}
Content-Type: application/json
```

**Başarılı Response (200):**
```json
{"id": 1, "text": "Merhaba"}
```

**Bulunamadı Response (404):**
```json
{"error": "Message not found with id: 999"}
```

## cURL Örnekleri

```bash
# Health check
curl http://localhost:8080/

# Tüm mesajları getir
curl http://localhost:8080/api/v1/messages

# Belirli bir mesajı getir
curl http://localhost:8080/api/v1/messages/1

# Olmayan mesaj için 404 test et
curl http://localhost:8080/api/v1/messages/999
```

## Testleri Çalıştırma

```bash
# Tüm testleri çalıştır
mvn test

# Belirli test sınıfını çalıştır
mvn test -Dtest=MessageServiceImplTest
mvn test -Dtest=MessageControllerTest
```

## Proje Yapısı

```
src/
├── main/
│   ├── java/com/bacooo/generic_modul/
│   │   ├── GenericModulApplication.java
│   │   ├── controller/
│   │   │   └── MessageController.java
│   │   ├── service/
│   │   │   ├── MessageService.java
│   │   │   └── impl/
│   │   │       └── MessageServiceImpl.java
│   │   ├── repository/
│   │   │   ├── MessageRepository.java
│   │   │   └── InMemoryMessageRepository.java
│   │   ├── model/
│   │   │   └── MessageDto.java
│   │   └── config/
│   │       └── GlobalExceptionHandler.java
│   └── resources/
│       └── application.properties
└── test/
    └── java/com/bacooo/generic_modul/
        ├── service/impl/
        │   └── MessageServiceImplTest.java
        └── controller/
            └── MessageControllerTest.java
```

## Özellikler

- **MVC Mimarisi**: Controller → Service → Repository katmanları
- **SOLID Prensipleri**: Özellikle SRP (Single Responsibility) ve DIP (Dependency Inversion)
- **In-Memory Veri**: Basit veri depolama için bellekte tutulan mesajlar
- **Global Exception Handling**: 404 hataları için merkezi hata yönetimi
- **Lombok**: Boilerplate kod azaltma (@Data, @AllArgsConstructor, @NoArgsConstructor, @RequiredArgsConstructor)
- **Logging**: SLF4J ile loglama
- **Testler**: Unit testler (Mockito) ve Integration testler (@WebMvcTest)
- **Validation**: Jakarta Validation ile basit validasyonlar

## 🐳 Docker ile Çalıştırma

### Gereksinimler
- Docker
- Docker Compose

### Yerel Docker Çalıştırma

```bash
# Docker container'ı build et ve çalıştır
docker-compose up --build -d

# Logları görüntüle
docker-compose logs -f

# Container'ı durdur
docker-compose down
```

## 🍓 Raspberry Pi'ye Deployment

### Ön Gereksinimler
- Raspberry Pi'de Ubuntu/Raspberry Pi OS
- Docker ve Docker Compose kurulu
- SSH erişimi aktif

### 1. Raspberry Pi'yi Hazırla

```bash
# Pi'ye SSH bağlantısı
ssh pi@<PI_IP_ADDRESS>

# Docker kurulumu (eğer kurulu değilse)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
sudo systemctl enable docker
sudo systemctl start docker

# Docker Compose kurulumu
sudo apt update
sudo apt install docker-compose-plugin
```

### 2. Projeyi Pi'ye Deploy Et

```bash
# Deployment script'ini çalıştır
chmod +x scripts/*.sh
./scripts/deploy-to-pi.sh <PI_IP_ADDRESS> <USERNAME>

# Örnek:
./scripts/deploy-to-pi.sh 192.168.1.100 pi
```

### 3. Pi'deki Uygulamayı Kontrol Et

```bash
# Durum kontrolü
./scripts/check-pi-status.sh 192.168.1.100 pi

# Uygulamayı durdur
./scripts/stop-pi-app.sh 192.168.1.100 pi
```

## 🌐 Ağ Üzerinden Erişim

Pi'ye deploy ettikten sonra, aynı ağdaki tüm cihazlardan erişebilirsin:

### Pi'nin IP Adresini Bul
```bash
# Pi üzerinde çalıştır
hostname -I
# veya
ip route get 1.1.1.1 | awk '{print $7}'
```

### Diğer Bilgisayarlardan İstek Atma

```bash
# Health check (Pi'nin IP'si ile değiştir)
curl http://192.168.1.100:8080/

# Tüm mesajları getir
curl http://192.168.1.100:8080/api/v1/messages

# Belirli mesaj
curl http://192.168.1.100:8080/api/v1/messages/1

# Web tarayıcıdan
# http://192.168.1.100:8080/
# http://192.168.1.100:8080/api/v1/messages
```

### PowerShell (Windows)
```powershell
# Health check
Invoke-RestMethod -Uri "http://192.168.1.100:8080/" -Method Get

# API çağrısı
Invoke-RestMethod -Uri "http://192.168.1.100:8080/api/v1/messages" -Method Get
```

### Python Script
```python
import requests

PI_IP = "192.168.1.100"
BASE_URL = f"http://{PI_IP}:8080"

# Health check
response = requests.get(f"{BASE_URL}/")
print(f"Health: {response.text}")

# Messages
response = requests.get(f"{BASE_URL}/api/v1/messages")
print(f"Messages: {response.json()}")
```

## 🔧 Troubleshooting

### Pi'ye Bağlanamıyorum
```bash
# Pi'nin ağda olup olmadığını kontrol et
ping <PI_IP>

# SSH portunu kontrol et
nmap -p 22 <PI_IP>
```

### Docker Sorunları
```bash
# Pi'de Docker durumunu kontrol et
ssh pi@<PI_IP> "docker ps"
ssh pi@<PI_IP> "docker-compose -f /home/pi/generic-modul/docker-compose.yml ps"

# Logları kontrol et
ssh pi@<PI_IP> "docker logs generic-modul-app"
```

### Port Sorunları
```bash
# Pi'de 8080 portunu kontrol et
ssh pi@<PI_IP> "netstat -tlnp | grep 8080"
```

## 📱 Mobil/Diğer Cihazlardan Test

Mobil cihazlardan da test edebilirsin:
- **Android**: Termux uygulaması ile curl
- **iOS**: Shortcuts uygulaması ile HTTP Request
- **Tarayıcı**: Direkt IP adresi ile erişim