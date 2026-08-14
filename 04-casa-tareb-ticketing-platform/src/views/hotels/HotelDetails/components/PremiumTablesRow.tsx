import { useState, useEffect } from "react";
import { usePanier } from '../../../../states';
import "./PremiumTablesRow.css";
import { EventBean, PlaceBean } from "../../../../states/stateModels";

//const seatsNumbers: number[] = Array.from({ length: 12 }, (_, i) => i + 1);

interface PremiumTablesRowProps {
  onCommande: (tableCode: string, chairNumber?: number) => void;
  price: number;
  event: EventBean;
  statePlaces: PlaceBean[];
}

 const tableList = [
  {table:'1',nbchair:6},
  {table:'2',nbchair:6},
  {table:'3',nbchair:6},
  {table:'4',nbchair:6},
  {table:'5',nbchair:6},
  {table:'6',nbchair:6},
  {table:'7',nbchair:6},
  {table:'8',nbchair:6},
  {table:'9',nbchair:6},
  {table:'10',nbchair:6},
  {table:'11',nbchair:6},
  {table:'12',nbchair:6}
];




export default function PremiumTablesRow({ onCommande, price, event, statePlaces }: PremiumTablesRowProps) {
  const { items, addItem, removeItem } = usePanier();
    const [tableSeats, setTableSeats] = useState<Record<number, Set<number>>>({}); 
  
    const [selectedChairs, setSelectedChairs] = useState<Record<string, boolean>>({});
    const [selectedTables, setSelectedTables] = useState<number[]>([]);
  
    // Charger au montage
  useEffect(() => {
    const savedChairs = localStorage.getItem('premiumSelectedChairs');
    const savedTables = localStorage.getItem('premiumSelectedTables');
    if (savedChairs) setSelectedChairs(JSON.parse(savedChairs));
    if (savedTables) setSelectedTables(JSON.parse(savedTables));
  }, []);
  
  // Sauvegarder à chaque changement
  useEffect(() => {
    localStorage.setItem('premiumSelectedChairs', JSON.stringify(selectedChairs));
  }, [selectedChairs]);
  
  useEffect(() => {
    localStorage.setItem('premiumSelectedTables', JSON.stringify(selectedTables));
  }, [selectedTables]);
  
  // 🔹 Réinitialiser les sélections quand le panier est vidé
  useEffect(() => {
    if (items.length === 0) {
      setSelectedChairs({});
      setSelectedTables([]);
      setTableSeats({});
      localStorage.removeItem('premiumSelectedChairs');
      localStorage.removeItem('premiumSelectedTables');
    }
  }, [items]);
  
  
    const doValidCommande = (table: string, chair?: number) => {
      if (chair) addItem({ tableNumber: table, chairNumber: chair, price, name: '', quantity: 1, event });
      onCommande(table, chair);
    };
  
    const removeItemFromPanier = (table: string, chair: number) => {
      items.filter(i => i.tableNumber === table && i.chairNumber === chair).forEach(i => removeItem(i.id));
    };
  
    // 🔹 Cliquer sur une chaise individuelle
    const handleChairClick = (
    tableIndex: number,
    tableName: string,
    chairNumber: number,
    status?: string
  ) => {
    if (status !== "0") return;
  
    const key = `${tableIndex}-${chairNumber}`;
  
    setSelectedChairs(prev => {
      const updated = { ...prev, [key]: !prev[key] };
  
      if (updated[key]) {
        doValidCommande(tableName, chairNumber);
      } else {
        removeItemFromPanier(tableName, chairNumber);
      }
  
      return updated;
    });
  };
  
  
  
    // 🔹 Cliquer sur une table
    const handleTableClick = (
    tableIndex: number,
    tableName: string,
    tableStatus?: string,
    nbSeats?: number
  ) => {
    if (tableStatus !== "0") return;
  
    const totalSeats = nbSeats || tableList[tableIndex].nbchair;
    const isSelected = selectedTables.includes(tableIndex);
  
    if (isSelected) {
      // 🔴 DÉSELECTION TABLE
      setSelectedTables(prev => prev.filter(i => i !== tableIndex));
  
      // 🔴 Supprimer seulement les chaises sélectionnées via cette table
      setSelectedChairs(prev => {
        const updated = { ...prev };
        const chairsByTable = tableSeats[tableIndex] || new Set<number>();
        chairsByTable.forEach(n => {
          delete updated[`${tableIndex}-${n}`];
        });
        return updated;
      });
  
      // 🔴 Supprimer du panier seulement ces chaises
      const chairsByTable = tableSeats[tableIndex] || new Set<number>();
      chairsByTable.forEach(n => {
        items
          .filter(i => i.tableNumber === tableName && i.chairNumber === n)
          .forEach(i => removeItem(i.id));
      });
  
      // 🔴 Supprimer l’enregistrement
      setTableSeats(prev => {
        const updated = { ...prev };
        delete updated[tableIndex];
        return updated;
      });
  
    } else {
      // 🟢 SÉLECTION TABLE
      setSelectedTables(prev => [...prev, tableIndex]);
  
      setSelectedChairs(prev => {
        const updated = { ...prev };
        const chairsByTable = new Set<number>();
  
        for (let n = 1; n <= totalSeats; n++) {
          const place = statePlaces.find(
            p => p.tableCode === tableName && Number(p.chairCode) === n
          );
          if (place?.status === "0" && !prev[`${tableIndex}-${n}`]) {
            updated[`${tableIndex}-${n}`] = true;
            doValidCommande(tableName, n);
            chairsByTable.add(n);
          }
        }
  
        setTableSeats(prev => ({ ...prev, [tableIndex]: chairsByTable }));
        return updated;
      });
    }
  };
  
  
  
    const getChairClass = (status?: string, isActive?: boolean) => {
      switch (status) {
        case "0": return isActive ? "premium-chair active" : "premium-chair available";
        case "1": return "premium-chair reserved";
        default: return "premium-chair disabled";
      }
    };
  
    const getTableClass = (tableIndex: number, tableStatus?: string) => {
      if (!tableStatus || tableStatus === "-1") return "premium-table-rect disabled";
      if (tableStatus === "1") return "premium-table-rect reserved";
      return selectedTables.includes(tableIndex) ? "premium-table-rect active" : "premium-table-rect available";
    };
  
    return (
      <div className="premium-cinema">
        <div className="premium-cinema-row">
          {tableList.map((tableBean, index) => {
            const tablePlaces = statePlaces.filter(p => p.tableCode === tableBean.table);
            const nbSeats = tablePlaces.length || tableBean.nbchair;
            const tableStatus = tablePlaces.length === 0 ? "-1" : tablePlaces[0].status;
  
            return (
              <div key={tableBean.table} className={`premium-table-wrapper ${tableStatus === "-1" ? "disabled" : ""}`}>
                <div className="premium-table-code">{tableBean.table}</div>
  
                <div className="premium-table-area">
                  {/* LEFT CHAIRS */}
                  <div className="premium-chairs">
                    {Array.from({ length: nbSeats / 2 }, (_, i) => i + 1).map(n => {
                      const key = `${index}-${n}`;
                      const place = tablePlaces.find(p => Number(p.chairCode) === n);
                      return (
                        <div
                          key={n}
                          className={getChairClass(place?.status, selectedChairs[key])}
                          onClick={() => handleChairClick(index, tableBean.table, n, place?.status)}
                        >
                          {n}
                        </div>
                      );
                    })}
                  </div>
  
                  {/* TABLE RECT */}
                  <div
                    className={getTableClass(index, tableStatus)}
                    onClick={() => handleTableClick(index, tableBean.table, tableStatus, nbSeats)}
                  />
  
                  {/* RIGHT CHAIRS */}
                  <div className="premium-chairs">
                    {Array.from({ length: nbSeats / 2 }, (_, i) => i + 1 + nbSeats / 2).map(n => {
                      const key = `${index}-${n}`;
                      const place = tablePlaces.find(p => Number(p.chairCode) === n);
                      return (
                        <div
                          key={n}
                          className={getChairClass(place?.status, selectedChairs[key])}
                          onClick={() => handleChairClick(index, tableBean.table, n, place?.status)}
                        >
                          {n}
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    );
  }