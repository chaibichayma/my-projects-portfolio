export interface CommandeItem {
  id: string;
  tableNumber: number;
  chairNumber: number;
  price: number;
  name?: string; // Optionnel : nom de l'article
  quantity: number;
}

export interface PanierContextType {
  items: CommandeItem[];
  addItem: (item: Omit<CommandeItem, 'id'>) => void;
  removeItem: (id: string) => void;
  updateItem: (id: string, updates: Partial<CommandeItem>) => void;
  clearPanier: () => void;
  getTotal: () => number;
  getItemCount: () => number;
}