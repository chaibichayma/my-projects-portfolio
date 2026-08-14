import React, { createContext, useContext, useState, ReactNode } from 'react';
import { CommandeItem, PanierContextType } from './stateModels';

const usePanierContext = createContext<PanierContextType | undefined>(undefined);

export const usePanier = () => {
  const context = useContext(usePanierContext);
  if (!context) {
    throw new Error('usePanier doit être utilisé dans un PanierProvider');
  }
  return context;
};

interface PanierProviderProps {
  children: ReactNode;
}

export const PanierProvider: React.FC<PanierProviderProps> = ({ children }) => {
  const [items, setItems] = useState<CommandeItem[]>(() => {
    const saved = localStorage.getItem("panierItems");
    return saved ? JSON.parse(saved) : [];
  });

  // 🔹 clearCounter doit être ici, à l'intérieur du composant
  const [clearCounter, setClearCounter] = useState(0);

  const saveItems = (newItems: CommandeItem[]) => {
    setItems(newItems);
    localStorage.setItem("panierItems", JSON.stringify(newItems));
  };

  const addItem = (itemData: Omit<CommandeItem, 'id'>) => {
    const newItem: CommandeItem = {
      ...itemData,
      id: Math.random().toString(36).substr(2, 9),
    };
    setItems(prev => {
      const updated = [...prev, newItem];
      localStorage.setItem("panierItems", JSON.stringify(updated));
      return updated;
    });
  };

  const removeItem = (id: string) => {
    saveItems(items.filter(item => item.id !== id));
  };

  const updateItem = (id: string, updates: Partial<CommandeItem>) => {
    saveItems(items.map(item => item.id === id ? { ...item, ...updates } : item));
  };

  const clearPanier = () => {
    saveItems([]);
    setClearCounter(prev => prev + 1); // 🔹 déclenche la réinitialisation
  };

  const getTotal = () => items.reduce((total, item) => total + item.price * item.quantity, 0);
  const getItemCount = () => items.reduce((count, item) => count + item.quantity, 0);

  return (
    <usePanierContext.Provider
      value={{ items, addItem, removeItem, updateItem, clearPanier, getTotal, getItemCount, clearCounter }}
    >
      {children}
    </usePanierContext.Provider>
  );
};
