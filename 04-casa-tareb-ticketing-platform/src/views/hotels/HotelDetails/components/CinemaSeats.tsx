import { useState, useEffect } from "react";
import "./RedTablesRow.css";
import { EventBean, PlaceBean } from "../../../../states/stateModels";
import { usePanier } from '../../../../states';
interface RedTablesRowProps {
  onCommande: (tableCode: string, chairNumber?: number) => void;
  price: number;
  event: EventBean;
  statePlaces: PlaceBean[];
}

export default function RedTablesRow({
  onCommande,
  price,
  event,
  statePlaces
}: RedTablesRowProps) {
  const { items, addItem, removeItem } = usePanier();
  const [tableSeats, setTableSeats] = useState<Record<number, Set<number>>>({}); 

  const [selectedChairs, setSelectedChairs] = useState<Record<string, boolean>>({});
  const [selectedTables, setSelectedTables] = useState<number[]>([]);

  const tableList = [
    { table: "1C", nbchair: 2 },
    { table: "2C", nbchair: 6 },
    { table: "3C", nbchair: 6 },
    { table: "4C", nbchair: 6 },
    { table: "5C", nbchair: 6 },
    { table: "6C", nbchair: 6 },
    { table: "7C", nbchair: 4 },
    { table: "8C", nbchair: 6 },
    { table: "9C", nbchair: 6 },
    { table: "10C", nbchair: 6 },
    { table: "11C", nbchair: 2 }
  ];

   // Charger au montage
  useEffect(() => {
    const savedChairs = localStorage.getItem('redSelectedChairs');
    const savedTables = localStorage.getItem('redSelectedTables');
    if (savedChairs) setSelectedChairs(JSON.parse(savedChairs));
    if (savedTables) setSelectedTables(JSON.parse(savedTables));
  }, []);
  
  // Sauvegarder à chaque changement
  useEffect(() => {
    localStorage.setItem('redSelectedChairs', JSON.stringify(selectedChairs));
  }, [selectedChairs]);
  
  useEffect(() => {
    localStorage.setItem('redSelectedTables', JSON.stringify(selectedTables));
  }, [selectedTables]);
  
  // 🔹 Réinitialiser les sélections quand le panier est vidé
  useEffect(() => {
    if (items.length === 0) {
      setSelectedChairs({});
      setSelectedTables([]);
      setTableSeats({});
      localStorage.removeItem('redSelectedChairs');
      localStorage.removeItem('redSelectedTables');
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
        case "0": return isActive ? "red-chair active" : "red-chair available";
        case "1": return "red-chair reserved";
        default: return "red-chair disabled";
      }
    };
  
    const getTableClass = (tableIndex: number, tableStatus?: string) => {
      if (!tableStatus || tableStatus === "-1") return "red-table-rect disabled";
      if (tableStatus === "1") return "red-table-rect reserved";
      return selectedTables.includes(tableIndex) ? "red-table-rect active" : "red-table-rect available";
    };

  return (
    <div className="red-cinema">
      <div className="red-cinema-row">
        {tableList.map((tableBean, index) => {
          const tablePlaces = statePlaces.filter(p => p.tableCode === tableBean.table);
          const nbSeats = tablePlaces.length || tableBean.nbchair;
          const tableStatus = tablePlaces.length === 0 ? "-1" : tablePlaces[0].status;

          return (
            <div key={tableBean.table} className="red-table-wrapper">
              <div className="red-table-code">{tableBean.table}</div>

              <div className="red-table-area">
                {/* Gauche */}
                <div className="red-chairs">
                  {Array.from({ length: tableBean.nbchair / 2 }, (_, i) => i + 1).map(n => {
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

                {/* Table */}
                <div
                  className={getTableClass(index, tableStatus)}
                  onClick={() => handleTableClick(index, tableBean.table, tableStatus, nbSeats)}
                />

                {/* Droite */}
                <div className="red-chairs">
                  {Array.from({ length: tableBean.nbchair / 2 }, (_, i) => i + 1 + tableBean.nbchair / 2).map(n => {
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

