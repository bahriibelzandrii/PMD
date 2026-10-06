import 'package:flutter/material.dart';

/// Design System Color Palette for TaskMaster (Mobile Application Programming)
/// Supports 3 aesthetic styles (Cyber Neon, Pastel Noir, Bento Mint)
/// and full Light/Dark mode transitions (Lab 9).
class AppColors {
  AppColors._();

  // ===========================================================================
  // 1. PRIMITIVES
  // ===========================================================================
  // Dark Grayscale
  static const Color black = Color(0xFF000000);
  static const Color dark900 = Color(0xFF0B0D11); // Obsidian base (Ref 1)
  static const Color dark800 = Color(0xFF14171C); // Charcoal base (Ref 2)
  static const Color dark700 = Color(0xFF16181D); // Graphite base (Ref 3)
  static const Color dark600 = Color(0xFF1C2027); // Card dark
  static const Color dark500 = Color(0xFF242933); // Card subtle / Borders

  // Light Grayscale
  static const Color white = Color(0xFFFFFFFF);
  static const Color light100 = Color(0xFFF8FAFC);
  static const Color light200 = Color(0xFFF1F5F9);
  static const Color light300 = Color(0xFFE2E8F0);
  static const Color light400 = Color(0xFFCBD5E1);

  // Status & Priority Tokens
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityHighBg = Color(0x26EF4444);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityMediumBg = Color(0x26F59E0B);
  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityLowBg = Color(0x2610B981);

  // ===========================================================================
  // 2. THEME ACCENTS (3 Archetypes from references)
  // ===========================================================================
  // Theme 1: Cyber Neon (Reference 1)
  static const Color cyberLime = Color(0xFFD4FF00);
  static const Color cyberLimeText = Color(0xFF0B0D11);
  static const Color cyberCyan = Color(0xFF00F0FF);

  // Theme 2: Pastel Noir (Reference 2)
  static const Color pastelIceBlue = Color(0xFFD2E5F7);
  static const Color pastelIceBlueText = Color(0xFF0F172A);
  static const Color pastelPeach = Color(0xFFF6D3B3);
  static const Color pastelPeachText = Color(0xFF422006);

  // Theme 3: Bento Mint (Reference 3)
  static const Color bentoMint = Color(0xFF86EFAC);
  static const Color bentoMintText = Color(0xFF064E3B);
  static const Color bentoLemon = Color(0xFFFEF08A);
  static const Color bentoLemonText = Color(0xFF713F12);

  // ===========================================================================
  // 3. SEMANTIC TOKENS - DARK THEME (Default)
  // ===========================================================================
  static const Color darkBackground = Color(0xFF0D0F13);
  static const Color darkSurface = Color(0xFF15181F);
  static const Color darkSurfaceSubtle = Color(0xFF1E222B);
  static const Color darkBorder = Color(0xFF272D3A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // ===========================================================================
  // 4. SEMANTIC TOKENS - LIGHT THEME (Lab 9 requirement)
  // ===========================================================================
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // ===========================================================================
  // 5. CONVENIENCE ALIASES (Used in screens)
  // ===========================================================================
  static const Color bgObsidian = darkBackground;
  static const Color bgCard = darkSurface;
  static const Color bgSurface = darkSurfaceSubtle;
  static const Color borderSubtle = darkBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;
  static const Color textInverse = Color(0xFF0D0F13);

  static const Color limePrimary = cyberLime;
  static const Color cyanAccent = cyberCyan;
  static const Color cardBlue = pastelIceBlue;
  static const Color cardBlueText = pastelIceBlueText;
  static const Color cardPeach = pastelPeach;
  static const Color cardPeachText = pastelPeachText;
  static const Color highPriorityRed = priorityHigh;
}
