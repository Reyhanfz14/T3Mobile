import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator BMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        useMaterial3: true,
      ),
      home: const BMIHomePage(),
    );
  }
}

class BMIHomePage extends StatefulWidget {
  const BMIHomePage({super.key});

  @override
  State<BMIHomePage> createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _selectedGender = 'Laki-laki';
  double? _bmiResult;
  String _bmiCategory = '';
  String _genderSpecificAdvice = '';

  void _calculateBMI() {
    final double? weight = double.tryParse(_weightController.text);
    final double? heightCm = double.tryParse(_heightController.text);

    if (weight == null || heightCm == null || weight <= 0 || heightCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap masukkan berat dan tinggi badan yang valid!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final double heightM = heightCm / 100;
    final double bmi = weight / (heightM * heightM);

    setState(() {
      _bmiResult = bmi;
      _evaluateBMICategory(bmi, _selectedGender);
    });
  }

  void _evaluateBMICategory(double bmi, String gender) {
    if (gender == 'Laki-laki') {
      if (bmi < 18.5) {
        _bmiCategory = 'Kekurangan Berat Badan (Underweight)';
        _genderSpecificAdvice =
            'Bagi pria, kekurangan berat badan dapat mempengaruhi massa otot dan stamina. '
            'Disarankan meningkatkan asupan protein tinggi dan latihan beban (strength training).';
      } else if (bmi >= 18.5 && bmi < 25.0) {
        _bmiCategory = 'Berat Badan Normal (Ideal)';
        _genderSpecificAdvice =
            'Pertahankan komposisi tubuh Anda! Kombinasikan olahraga kardio dan latihan kekuatan '
            'untuk menjaga kesehatan jantung dan massa otot pria.';
      } else if (bmi >= 25.0 && bmi < 30.0) {
        _bmiCategory = 'Kelebihan Berat Badan (Overweight)';
        _genderSpecificAdvice =
            'Pria cenderung menyimpan lemak visceral di sekitar perut. '
            'Fokuskan pada pengurangan kalori harian dan tingkatkan aktivitas fisik.';
      } else {
        _bmiCategory = 'Obesitas';
        _genderSpecificAdvice =
            'Risiko kesehatan meningkat untuk pria dengan kategori ini (terutama kesehatan jantung). '
            'Konsultasikan dengan ahli gizi atau dokter untuk program penurunan berat badan yang aman.';
      }
    } else {
      if (bmi < 18.5) {
        _bmiCategory = 'Kekurangan Berat Badan (Underweight)';
        _genderSpecificAdvice =
            'Bagi wanita, berat badan terlalu rendah dapat mengganggu siklus menstruasi dan kesehatan hormon. '
            'Disarankan menambah nutrisi seimbang kaya zat besi dan asam lemak sehat.';
      } else if (bmi >= 18.5 && bmi < 24.5) {
        _bmiCategory = 'Berat Badan Normal (Ideal)';
        _genderSpecificAdvice =
            'Berat badan Anda berada di rentang yang sangat baik untuk keseimbangan hormon dan kesuburan wanita. '
            'Pertahankan dengan pola makan bergizi dan olahraga teratur seperti yoga atau pilates.';
      } else if (bmi >= 24.5 && bmi < 29.5) {
        _bmiCategory = 'Kelebihan Berat Badan (Overweight)';
        _genderSpecificAdvice =
            'Wanita pada rentang ini disarankan untuk menjaga asupan gula dan karbohidrat olahan, '
            'serta rutin melakukan latihan kardio ringan hingga sedang.';
      } else {
        _bmiCategory = 'Obesitas';
        _genderSpecificAdvice =
            'Risiko kesehatan seperti gangguan metabolik dapat meningkat. '
            'Disarankan melakukan pendekatan penurunan berat badan yang berkelanjutan dan berkonsultasi dengan profesional.';
      }
    }
  }

  void _resetForm() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmiResult = null;
      _bmiCategory = '';
      _genderSpecificAdvice = '';
      _selectedGender = 'Laki-laki';
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalkulator BMI Pintar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue.shade700,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Jenis Kelamin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.male, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Laki-laki'),
                              ],
                            ),
                            selected: _selectedGender == 'Laki-laki',
                            selectedColor: Colors.lightBlue.shade100,
                            onSelected: (selected) {
                              setState(() {
                                _selectedGender = 'Laki-laki';
                                if (_bmiResult != null) {
                                  _evaluateBMICategory(
                                    _bmiResult!,
                                    _selectedGender,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.female, color: Colors.pink),
                                SizedBox(width: 8),
                                Text('Perempuan'),
                              ],
                            ),
                            selected: _selectedGender == 'Perempuan',
                            selectedColor: Colors.pink.shade100,
                            onSelected: (selected) {
                              setState(() {
                                _selectedGender = 'Perempuan';
                                if (_bmiResult != null) {
                                  _evaluateBMICategory(
                                    _bmiResult!,
                                    _selectedGender,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Berat Badan (kg)',
                        prefixIcon: const Icon(
                          Icons.fitness_center,
                          color: Colors.lightBlue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _heightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Tinggi Badan (cm)',
                        prefixIcon: const Icon(
                          Icons.height,
                          color: Colors.lightBlue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _calculateBMI,
                    icon: const Icon(Icons.calculate, color: Colors.white),
                    label: const Text(
                      'Hitung BMI',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.refresh, color: Colors.redAccent),
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.redAccent,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_bmiResult != null) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Hasil Analisis BMI (${_selectedGender})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _bmiResult!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _bmiCategory,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Saran Kesehatan Khusus:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _genderSpecificAdvice,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
