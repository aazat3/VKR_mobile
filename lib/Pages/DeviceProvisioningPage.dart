import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceProvisioningPage extends StatefulWidget {
  const DeviceProvisioningPage({super.key});

  @override
  State<DeviceProvisioningPage> createState() => _DeviceProvisioningPageState();
}

class _DeviceProvisioningPageState extends State<DeviceProvisioningPage> {
  // UUID сервиса и характеристики
  static const String serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const String characteristicUUID =
      "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  bool isConnecting = false;
  bool isConnected = false;
  BluetoothDevice? connectedDevice;
  String status = "Нажмите 'Поиск устройств' для начала сканирования";
  // final TextEditingController ssidController = TextEditingController();
  List<WiFiAccessPoint> wifiList = [];
  // WiFiAccessPoint? selectedNetwork;
  String? selectedSSID;
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.scanResults.listen((results) {
      setState(() => scanResults = results);
    });
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  void startScan() {
    setState(() {
      scanResults.clear();
      isScanning = true;
      status = "Сканирование...";
    });

    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 15),
      withServices: [Guid(serviceUUID)],
    );

    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          isScanning = false;
          if (scanResults.isEmpty) {
            status = "Устройства не найдены";
          } else {
            status = "Выберите устройство для подключения";
          }
        });
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
      status = "Подключение к ${device.advName}...";
    });

    try {
      await device.connect(autoConnect: false);
      setState(() {
        connectedDevice = device;
        isConnected = true;
        isConnecting = false;
        status = "Подключено к ${device.advName}";
      });
    } catch (e) {
      setState(() {
        isConnecting = false;
        status = "Ошибка подключения: ${e.toString()}";
      });
    }
  }

  Future<void> sendCredentials() async {
    if (selectedSSID == null || selectedSSID!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Выберите Wi-Fi сеть")));
      return;
    }

    final ssid = selectedSSID!;
    final password = passwordController.text;
    final credentials = "$ssid:$password";

    if (connectedDevice == null) return;

    setState(() => status = "Отправка данных...");

    try {
      final services = await connectedDevice!.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid.toString() == serviceUUID,
        orElse: () => throw "Сервис не найден",
      );

      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid.toString() == characteristicUUID,
        orElse: () => throw "Характеристика не найдена",
      );

      await characteristic.write(credentials.codeUnits);
      setState(() => status = "Данные успешно отправлены!");
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } catch (e) {
      setState(() => status = "Ошибка: ${e.toString()}");
    }
  }

  Future<void> scanWiFiNetworks() async {
    final permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
      setState(() => status = "Нет доступа к геолокации");
      return;
    }

    final canScan = await WiFiScan.instance.canStartScan();
    switch (canScan) {
      case CanStartScan.yes:
        break; // можно сканировать
      case CanStartScan.notSupported:
        setState(() => status = "Сканирование не поддерживается устройством");
        return;
      case CanStartScan.noLocationPermissionRequired:
        setState(() => status = "Требуется разрешение на локацию");
        return;
      case CanStartScan.noLocationPermissionDenied:
        setState(() => status = "Разрешение на локацию отклонено");
        return;
      case CanStartScan.noLocationPermissionUpgradeAccuracy:
        setState(
          () => status = "Требуется повысить точность разрешения на локацию",
        );
        return;
      case CanStartScan.noLocationServiceDisabled:
        setState(() => status = "Служба геолокации отключена");
        return;
      case CanStartScan.failed:
        setState(() => status = "Не удалось запустить сканирование");
        return;
    }

    await WiFiScan.instance.startScan();
    await Future.delayed(
      const Duration(seconds: 2),
    ); // подождать завершения сканирования
    final results = await WiFiScan.instance.getScannedResults();

    setState(() {
      wifiList = results;
      status = "Выберите Wi-Fi сеть";
    });
  }

  Widget _buildDeviceList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: scanResults.length,
      itemBuilder: (context, index) {
        final result = scanResults[index];
        return ListTile(
          leading: const Icon(Icons.device_unknown),
          title: Text(
            result.device.advName.isEmpty
                ? "Unknown Device"
                : result.device.advName,
          ),
          subtitle: Text(result.device.remoteId.toString()),
          trailing:
              isConnecting &&
                      connectedDevice?.remoteId == result.device.remoteId
                  ? const CircularProgressIndicator()
                  : null,
          onTap: () {
            if (!isConnecting) {
              connectToDevice(result.device);
            }
          },
        );
      },
    );
  }

  Widget _buildConnectionForm() {
    scanWiFiNetworks();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          items:
              wifiList
                  .map(
                    (ap) => DropdownMenuItem(
                      value: ap.ssid,
                      child: Text(ap.ssid.isEmpty ? "<без имени>" : ap.ssid),
                    ),
                  )
                  .toList(),
          onChanged: (ssid) => setState(() => selectedSSID = ssid),
          value: selectedSSID,
          decoration: const InputDecoration(
            labelText: "Выберите Wi-Fi сеть",
            prefixIcon: Icon(Icons.wifi),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: "Пароль сети",
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: sendCredentials,
          child: const Text("Отправить настройки"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройка устройства"),
        actions: [
          if (isScanning)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                FlutterBluePlus.stopScan();
                setState(() => isScanning = false);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Статус подключения
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.bluetooth, size: 48),
                    const SizedBox(height: 10),
                    Text(
                      status,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Список устройств или форма настроек
            if (!isConnected && !isConnecting && scanResults.isNotEmpty)
              Expanded(child: _buildDeviceList()),

            if (isConnected) _buildConnectionForm(),

            // Кнопка поиска
            if (!isScanning && !isConnected)
              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Поиск устройств"),
                onPressed: isConnecting ? null : startScan,
              ),
          ],
        ),
      ),
      floatingActionButton:
          isConnected
              ? FloatingActionButton(
                onPressed: () async {
                  await connectedDevice?.disconnect();
                  setState(() {
                    isConnected = false;
                    connectedDevice = null;
                    status = "Отключено";
                  });
                },
                child: const Icon(Icons.bluetooth_disabled),
              )
              : null,
    );
  }
}
