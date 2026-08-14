export interface CommandeItem {
  id: string;
  tableNumber: string;
  chairNumber?: number;
  price: number;
  name?: string; // Optionnel : nom de pariticipant
  mail?: string; // Optionnel : nom de pariticipant
  quantity: number;
  event:EventBean;
}

export interface EventBean {
    isSoldOut: boolean;
     id:number;
	  title: string;
	  description: string;
	  urlImage: string;
	  detailImage: string;
	  priceTicket: number;
	  availableTicket: number;
	  eventDate: string;
	  eventDay: string;
	  eventHour: string;
	  duraction: string;
	  planImage: string;
}

export interface ZoneBean {
     id:number;
	  title: string;
	  displayColor: string;
	  keyname: string;
	  available: number;
	  price: number;
}

export interface PlaceBean {
  tableId: number;
  tableCode: string;
  chairCode: string;
  status: string; // 0=libre, 1=occupé, 2=desactive
}


export interface TableConfig {
  table: string;
  nbchair: number;
}


// stateModels.ts ou le fichier où tu as défini PanierContextType
export interface PanierContextType {
  items: CommandeItem[];
  addItem: (itemData: Omit<CommandeItem, 'id'>) => void;
  removeItem: (id: string) => void;
  updateItem: (id: string, updates: Partial<CommandeItem>) => void;
  clearPanier: () => void;
  getTotal: () => number;
  getItemCount: () => number;

  // 🔹 ajouter ceci
  clearCounter: number;
}
