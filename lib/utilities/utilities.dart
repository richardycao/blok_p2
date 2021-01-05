import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class CharIcon {
  Map<String, IconData> _icons = {
    'A': Mdi.alphaACircle,
    'B': Mdi.alphaBCircle,
    'C': Mdi.alphaCCircle,
    'D': Mdi.alphaDCircle,
    'E': Mdi.alphaECircle,
    'F': Mdi.alphaFCircle,
    'G': Mdi.alphaGCircle,
    'H': Mdi.alphaHCircle,
    'I': Mdi.alphaICircle,
    'J': Mdi.alphaJCircle,
    'K': Mdi.alphaKCircle,
    'L': Mdi.alphaLCircle,
    'M': Mdi.alphaMCircle,
    'N': Mdi.alphaNCircle,
    'O': Mdi.alphaOCircle,
    'P': Mdi.alphaPCircle,
    'Q': Mdi.alphaQCircle,
    'R': Mdi.alphaRCircle,
    'S': Mdi.alphaSCircle,
    'T': Mdi.alphaTCircle,
    'U': Mdi.alphaUCircle,
    'V': Mdi.alphaVCircle,
    'W': Mdi.alphaWCircle,
    'X': Mdi.alphaXCircle,
    'Y': Mdi.alphaYCircle,
    'Z': Mdi.alphaZCircle,
    '0': Mdi.numeric0Circle,
    '1': Mdi.numeric1Circle,
    '2': Mdi.numeric2Circle,
    '3': Mdi.numeric3Circle,
    '4': Mdi.numeric4Circle,
    '5': Mdi.numeric5Circle,
    '6': Mdi.numeric6Circle,
    '7': Mdi.numeric7Circle,
    '8': Mdi.numeric8Circle,
    '9': Mdi.numeric9Circle,
  };

  IconData char(String char) {
    return _icons[char.toUpperCase()];
  }
}
