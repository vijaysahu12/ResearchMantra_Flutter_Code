class Validator {
  // Validation functions
static String? validateCapitalAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter capital amount';
    }
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid amount';
    }
    return null;
  }

static  String? validateRiskPercentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter risk percentage';
    }
    final number = double.tryParse(value);
    if (number == null || number < 1 || number > 100) {
      return '1% - 99% risk is allowed';
    }
    return null;
  }

static  String? validateEntryPrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Entry price';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid price';
    }
    return null;
  }

static  String? validateStopLoss(String? value, bool isBuySelected , String controllerText) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Stop Loss';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid price';
    }

    final entryPrice = double.tryParse(controllerText) ?? 0;
    if (isBuySelected && parsed >= entryPrice) {
      return 'Stop Loss must be less than Entry'; // for BUY
    } else if (!isBuySelected && parsed <= entryPrice) {
      return 'Stop Loss must be more than Entry'; // for SELL
    }
    return null;
  }

static  String? validateTargetPrice(String? value, bool isBuySelected , String controllerText) {
    if (value == null || value.trim().isEmpty) {
      return 'Please set Target Price';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid value';
    }

    final entryPrice = double.tryParse(controllerText) ?? 0;
    if (isBuySelected && parsed <= entryPrice) {
      return 'Target must be more than Entry';
    } else if (!isBuySelected && parsed >= entryPrice) {
      return 'Target must be less than Entry';
    }
    return null;
  }
}