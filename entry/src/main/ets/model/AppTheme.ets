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
  textOnPrimaryMuted: string;
  success: string;
  error: string;
  warning: string;
  divider: string;
  tabInactive: string;
  overlayScrim: string;
  glassBg: string;
  glassBorder: string;
  optionCorrectBg: string;
  optionWrongBg: string;
  optionDefaultBg: string;
}

export const THEMES: AppTheme[] = [
  {
    name: '天空蓝',
    primary: '#1976D2',
    primaryLight: '#42A5F5',
    primaryGradientStart: '#1565C0',
    primaryGradientEnd: '#42A5F5',
    background: '#F0F4F8',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#1A237E',
    textSecondary: '#5C6B7A',
    textOnPrimary: '#FFFFFF',
    textOnPrimaryMuted: 'rgba(255,255,255,0.85)',
    success: '#43A047',
    error: '#E53935',
    warning: '#FB8C00',
    divider: '#E3E8EF',
    tabInactive: '#9AA5B1',
    overlayScrim: 'rgba(0,0,0,0.45)',
    glassBg: 'rgba(255,255,255,0.28)',
    glassBorder: 'rgba(255,255,255,0.55)',
    optionCorrectBg: '#C8E6C9',
    optionWrongBg: '#FFCDD2',
    optionDefaultBg: '#E3F2FD'
  },
  {
    name: '清新绿',
    primary: '#2E7D32',
    primaryLight: '#66BB6A',
    primaryGradientStart: '#1B5E20',
    primaryGradientEnd: '#66BB6A',
    background: '#F1F8E9',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#1B3A1E',
    textSecondary: '#55705A',
    textOnPrimary: '#FFFFFF',
    textOnPrimaryMuted: 'rgba(255,255,255,0.85)',
    success: '#43A047',
    error: '#E53935',
    warning: '#FB8C00',
    divider: '#D7E8D9',
    tabInactive: '#8AA091',
    overlayScrim: 'rgba(0,0,0,0.45)',
    glassBg: 'rgba(255,255,255,0.28)',
    glassBorder: 'rgba(255,255,255,0.55)',
    optionCorrectBg: '#C8E6C9',
    optionWrongBg: '#FFCDD2',
    optionDefaultBg: '#F1F8E9'
  },
  {
    name: '浅紫色',
    primary: '#7B1FA2',
    primaryLight: '#AB47BC',
    primaryGradientStart: '#6A1B9A',
    primaryGradientEnd: '#AB47BC',
    background: '#F3E5F5',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#311B92',
    textSecondary: '#6B5B8A',
    textOnPrimary: '#FFFFFF',
    textOnPrimaryMuted: 'rgba(255,255,255,0.85)',
    success: '#43A047',
    error: '#E53935',
    warning: '#FB8C00',
    divider: '#E8DCE8',
    tabInactive: '#9E8FA8',
    overlayScrim: 'rgba(0,0,0,0.45)',
    glassBg: 'rgba(255,255,255,0.28)',
    glassBorder: 'rgba(255,255,255,0.55)',
    optionCorrectBg: '#C8E6C9',
    optionWrongBg: '#FFCDD2',
    optionDefaultBg: '#F3E5F5'
  },
  {
    name: '暖橙色',
    primary: '#E65100',
    primaryLight: '#FF9800',
    primaryGradientStart: '#D84315',
    primaryGradientEnd: '#FF9800',
    background: '#FFF3E0',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#3E2723',
    textSecondary: '#795548',
    textOnPrimary: '#FFFFFF',
    textOnPrimaryMuted: 'rgba(255,255,255,0.85)',
    success: '#43A047',
    error: '#E53935',
    warning: '#FB8C00',
    divider: '#FFE0B2',
    tabInactive: '#A1887F',
    overlayScrim: 'rgba(0,0,0,0.45)',
    glassBg: 'rgba(255,255,255,0.28)',
    glassBorder: 'rgba(255,255,255,0.55)',
    optionCorrectBg: '#C8E6C9',
    optionWrongBg: '#FFCDD2',
    optionDefaultBg: '#FFF3E0'
  },
  {
    name: '玫瑰红',
    primary: '#C62828',
    primaryLight: '#EF5350',
    primaryGradientStart: '#B71C1C',
    primaryGradientEnd: '#EF5350',
    background: '#FFEBEE',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#B71C1C',
    textSecondary: '#7A5A5A',
    textOnPrimary: '#FFFFFF',
    textOnPrimaryMuted: 'rgba(255,255,255,0.85)',
    success: '#43A047',
    error: '#E53935',
    warning: '#FB8C00',
    divider: '#FFCDD2',
    tabInactive: '#A89B9B',
    overlayScrim: 'rgba(0,0,0,0.45)',
    glassBg: 'rgba(255,255,255,0.28)',
    glassBorder: 'rgba(255,255,255,0.55)',
    optionCorrectBg: '#C8E6C9',
    optionWrongBg: '#FFCDD2',
    optionDefaultBg: '#FFEBEE'
  },
  {
    name: '深空灰',
    primary: '#37474F',
    primaryLight: '#607D8B',
    primaryGradientStart: '#263238',
    primaryGradientEnd: '#607D8B',
    background: '#ECEFF1',
    surface: '#FFFFFF',
    card: '#FFFFFF',
    textPrimary: '#263238',
    textSecondary: '#607D8B',
    textOnPrimary: '#FFFFFF',
    textOnPrimaryMuted: 'rgba(255,255,255,0.85)',
    success: '#43A047',
    error: '#E53935',
    warning: '#FB8C00',
    divider: '#CFD8DC',
    tabInactive: '#90A4AE',
    overlayScrim: 'rgba(0,0,0,0.45)',
    glassBg: 'rgba(255,255,255,0.28)',
    glassBorder: 'rgba(255,255,255,0.55)',
    optionCorrectBg: '#C8E6C9',
    optionWrongBg: '#FFCDD2',
    optionDefaultBg: '#ECEFF1'
  }
];

export const DEFAULT_THEME_INDEX = 0;
