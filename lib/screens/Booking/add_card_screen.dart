import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:real_estate_app/constant/constant_color.dart';

import '../../Service/auth_service.dart';

// Simple model to hold card data
class CardData {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;

  CardData({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
  });

  // Get last 4 digits of card number for display
  String get maskedCardNumber {
    if (cardNumber.isEmpty) return '';
    // Remove spaces and get last 4 digits
    String digitsOnly = cardNumber.replaceAll(' ', '');
    if (digitsOnly.length >= 4) {
      return '**** **** **** ${digitsOnly.substring(digitsOnly.length - 4)}';
    }
    return cardNumber;
  }

  // Get card brand based on number
  String get cardBrand {
    if (cardNumber.isEmpty) return 'Card';
    
    String cleanedNumber = cardNumber.replaceAll(' ', '');
    
    if (cleanedNumber.startsWith('4')) {
      return 'Visa';
    } else if (cleanedNumber.startsWith('5') || cleanedNumber.startsWith('2')) {
      return 'Mastercard';
    } else if (cleanedNumber.startsWith('3')) {
      return 'Amex';
    } else {
      return 'Card';
    }
  }
}

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  AuthService _authService = AuthService();
  User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _saveCardData() async {
    if (_currentUser == null) return;

    try {
      Map<String, dynamic> updateData = {
        'cardnumber' : cardNumber.trim(),
        'cardexpiry' : expiryDate.trim(),
        'cardcvv' : cvvCode.trim(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card Added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding card: ${e.toString()}')));
    }
  }

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Add Card',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,size: 20,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                bankName: 'Card',
                cardBgColor: Color(0xFFA32E7E),
                // enableFloatingCard: true,
                backgroundImage: '',
                labelValidThru: 'VALID\nTHRU',
                obscureCardNumber: true,
                obscureInitialCardNumber: false,
                obscureCardCvv: false,
                labelCardHolder: 'CARD HOLDER',
                cardType: CardType.mastercard,
                isHolderNameVisible: true,
                height: 200,
                textStyle: TextStyle(color: Colors.white),
                width: 400,
                isChipVisible: false,
                isSwipeGestureEnabled: true,
                animationDuration: Duration(milliseconds: 1000),
                frontCardBorder: Border.all(color: Colors.grey),
                backCardBorder: Border.all(color: Colors.grey),
                chipColor: Colors.grey,
                padding: 0,
                onCreditCardWidgetChange: (CreditCardBrand p1) {},
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _cardHolderNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter card holder name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card holder name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Card Number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '1234 5678 9012 3456',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        // Format card number with spaces every 4 digits
                        String formattedValue = formatCardNumber(value);
                        setState(() {
                          cardNumber = formattedValue;
                          _cardNumberController.text = formattedValue;
                          _cardNumberController.selection =
                              TextSelection.fromPosition(
                                TextPosition(offset: formattedValue.length),
                              );
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        // Remove spaces for validation
                        String cleanValue = value.replaceAll(' ', '');
                        if (cleanValue.length != 16) {
                          return 'Please enter a valid 16 digit card number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expired',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _expiryDateController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'MM/YY',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    expiryDate = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter expiry date';
                                  }
                                  if (!RegExp(
                                    r'^(0[1-9]|1[0-2])\/?([0-9]{2})$',
                                  ).hasMatch(value)) {
                                    return 'Please enter valid expiry date (MM/YY)';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cvv',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _cvvCodeController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'CVV',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    cvvCode = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter CVV';
                                  }
                                  if (value.length != 3) {
                                    return 'Please enter a valid 3 digit CVV';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Add Card Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Create card data object to pass back
                            final cardData = CardData(
                              cardNumber: cardNumber,
                              expiryDate: expiryDate,
                              cardHolderName: cardHolderName,
                              cvvCode: cvvCode,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Card added successfully!'),
                                backgroundColor: commonColor,
                              ),
                            );
                            _saveCardData();
                            Navigator.pop(context, cardData);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: commonColor, // Purple color
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add card',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to format card number with spaces
  String formatCardNumber(String value) {
    // Remove all non-digit characters
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 16 digits
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    // Add spaces every 4 digits
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += digitsOnly[i];
    }

    return formatted;
  }
}