import { changeHTMLAttribute } from '@/utils/layout';
import { createContext, useContext, useState } from 'react';
const LayoutContext = createContext(undefined);
function useLayoutContext() {
  const context = useContext(LayoutContext);
  if (context === undefined) {
    throw new Error('useLayoutContext must be used within an LayoutProvider');
  }
  return context;
}
const themeKey = 'data-bs-theme';
const LayoutProvider = ({
  children
}) => {
  const getSavedTheme = () => {
    const foundTheme = localStorage.getItem(themeKey);
    const preferredTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    if (foundTheme) {
      if (foundTheme === 'auto') {
        changeHTMLAttribute(themeKey, preferredTheme);
        return preferredTheme;
      }
      changeHTMLAttribute(themeKey, foundTheme);
      return foundTheme == 'dark' ? 'dark' : 'light';
    } else {
      localStorage.setItem(themeKey, preferredTheme);
      return preferredTheme;
    }
  };
  const INIT_STATE = {
    theme: getSavedTheme(),
    dir: 'ltr'
  };
  const [settings, setSettings] = useState(INIT_STATE);
  const updateSettings = _newSettings => setSettings({
    ...settings,
    ..._newSettings
  });
  const updateTheme = newTheme => {
    const foundTheme = localStorage.getItem(themeKey);
    if (foundTheme !== newTheme) {
      changeHTMLAttribute(themeKey, newTheme);
      localStorage.setItem(themeKey, newTheme);
      updateSettings({
        ...settings,
        theme: newTheme
      });
    }
  };
  const updateDir = newDir => updateSettings({
    ...settings,
    dir: newDir
  });
  return <LayoutContext.Provider value={{
    ...settings,
    updateTheme,
    updateDir
  }}>
      {children}
    </LayoutContext.Provider>;
};
export { useLayoutContext, LayoutProvider };