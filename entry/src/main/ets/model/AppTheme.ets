// 应用主题定义

export interface AppTheme {
  name: string;
  primary: string;
  primaryLight: string;
  primaryGradientStart: string;
  primaryGradientEnd: string;
  background: string;
  surface: string;
  card: string;
  textPrimary: string;
  textSecondary: string;
  textOnPrimary: string;
  success: string;
  error: string;
  warning: string;
  divider: string;
}

export const THEMES: AppTheme[] = [
  {
    name: '天空蓝',
    primary: '#1976D2',
    primaryLight: '#42A5F5',
    primaryGradientStart: '#1976D2',
    primaryGradientEnd: '#42A5F5',
    background: '#F5F5F5',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#212121',
    textSecondary: '#757575',
    textOnPrimary: '#FFFFFF',
    success: '#4CAF50',
    error: '#E53935',
    warning: '#FF9800',
    divider: '#E0E0E0'
  },
  {
    name: '清新绿',
    primary: '#2E7D32',
    primaryLight: '#66BB6A',
    primaryGradientStart: '#2E7D32',
    primaryGradientEnd: '#66BB6A',
    background: '#F1F8E9',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#212121',
    textSecondary: '#757575',
    textOnPrimary: '#FFFFFF',
    success: '#43A047',
    error: '#E53935',
    warning: '#FF9800',
    divider: '#E0E0E0'
  },
  {
    name: '浅紫色',
    primary: '#7B1FA2',
    primaryLight: '#AB47BC',
    primaryGradientStart: '#7B1FA2',
    primaryGradientEnd: '#AB47BC',
    background: '#F3E5F5',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#212121',
    textSecondary: '#757575',
    textOnPrimary: '#FFFFFF',
    success: '#43A047',
    error: '#E53935',
    warning: '#FF9800',
    divider: '#E0E0E0'
  }
];

export const DEFAULT_THEME_INDEX = 0;
