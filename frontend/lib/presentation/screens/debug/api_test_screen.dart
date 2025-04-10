import 'package:flutter/material.dart';

import '../../../data/services/api_service.dart';
import '../../../utils/logger.dart';

/// Debug screen to test API connectivity between frontend and backend
class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String _responseText = '';
  bool _isConnected = true;
  
  @override
  void initState() {
    super.initState();
    // Listen to connectivity changes
    _apiService.connectivityStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }
  
  Future<void> _testHealthEndpoint() async {
    setState(() {
      _isLoading = true;
      _responseText = '';
    });
    
    try {
      final response = await _apiService.get(
        endpoint: '/health',
      );
      
      setState(() {
        _responseText = 'Response: ${response.status}\n'
            'Message: ${response.message ?? 'No message'}\n'
            'Data: ${response.data != null ? 'Available' : 'None'}\n'
            'Full response: ${response.toString()}';
      });
    } catch (e) {
      AppLogger.e('Health check error: $e');
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _testAuthEndpoint() async {
    setState(() {
      _isLoading = true;
      _responseText = '';
    });
    
    try {
      final response = await _apiService.post(
        endpoint: '/auth/login',
        data: {
          'email': 'test@example.com',
          'password': 'password123',
        },
      );
      
      setState(() {
        _responseText = 'Response: ${response.status}\n'
            'Message: ${response.message ?? 'No message'}\n'
            'Errors: ${response.errors?.map((e) => '${e.field}: ${e.message}').join(', ') ?? 'None'}';
      });
    } catch (e) {
      AppLogger.e('Auth test error: $e');
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connection Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connectivity status
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: _isConnected ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    _isConnected ? Icons.wifi : Icons.wifi_off,
                    color: _isConnected ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    _isConnected ? 'Connected to network' : 'No network connection',
                    style: TextStyle(
                      color: _isConnected ? Colors.green.shade800 : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            Text(
              'Test API Connection',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16.0),
            
            // Health endpoint test
            ElevatedButton(
              onPressed: _isLoading ? null : _testHealthEndpoint,
              child: const Text('Test Health Endpoint'),
            ),
            
            const SizedBox(height: 12.0),
            
            // Auth endpoint test
            ElevatedButton(
              onPressed: _isLoading ? null : _testAuthEndpoint,
              child: const Text('Test Auth Endpoint'),
            ),
            
            const SizedBox(height: 24.0),
            
            // Progress indicator
            if (_isLoading) 
              const Center(child: CircularProgressIndicator()),
            
            const SizedBox(height: 16.0),
            
            // Response output
            if (_responseText.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Response:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SingleChildScrollView(
                    child: Text(_responseText),
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