import { useState, useEffect } from "react";
import { usePanier } from "../../../../states"; // si tu veux gérer le panier
import "./BlueTablesRow.css";
import { EventBean, PlaceBean } from "../../../../states/stateModels";

interface BlueTablesRowProps {
  onCommande: (tableCode: string, chairNumber?: number) => void;
  price: number;
  event: EventBean;
  statePlaces: PlaceBean[];
}

// 18 tables de 34 à 51, 10 chaises chacune
const tableList = Array.from({ length: 18 }, (_, i) => ({
  table: `${34 + i}`,
  nbchair: 10
}));

export default function BlueTablesRow({ onCommande, price, event, statePlaces }: BlueTablesRowProps) {
  const { items, addItem, removeItem } = usePanier();
  const [selectedChairs, setSelectedChairs] = useState<Record<string, boolean>>({});
  const [selectedTables, setSelectedTables] = useState<number[]>([]);
  const [tableSeats, setTableSeats] = useState<Record<number, Set<number>>>({});

  // Charger depuis localStorage
  useEffect(() => {
    const savedChairs = localStorage.getItem('blueSelectedChairs');
    const savedTables = localStorage.getItem('blueSelectedTables');
    if (savedChairs) setSelectedChairs(JSON.parse(savedChairs));
    if (savedTables) setSelectedTables(JSON.parse(savedTables));
  }, []);

  // Sauvegarder à chaque changement
  useEffect(() => {
    localStorage.setItem('blueSelectedChairs', JSON.stringify(selectedChairs));
  }, [selectedChairs]);

  useEffect(() => {
    localStorage.setItem('blueSelectedTables', JSON.stringify(selectedTables));
  }, [selectedTables]);

  // Reset si panier vide
  useEffect(() => {
    if (items.length === 0) {
      setSelectedChairs({});
      setSelectedTables([]);
      setTableSeats({});
      localStorage.removeItem('blueSelectedChairs');
      localStorage.removeItem('blueSelectedTables');
    }
  }, [items]);

  const doValidCommande = (table: string, chair?: number) => {
    if (chair) addItem({ tableNumber: table, chairNumber: chair, price, name: '', quantity: 1, event });
    onCommande(table, chair);
  };

  const removeItemFromPanier = (table: string, chair: number) => {
    items.filter(i => i.tableNumber === table && i.chairNumber === chair).forEach(i => removeItem(i.id));
  };

  // Clique sur chaise individuelle
  const handleChairClick = (tableIndex: number, tableName: string, chairNumber: number, status?: string) => {
    if (status !== "0") return;
    const key = `${tableIndex}-${chairNumber}`;
    setSelectedChairs(prev => {
      const updated = { ...prev, [key]: !prev[key] };
      if (updated[key]) doValidCommande(tableName, chairNumber);
      else removeItemFromPanier(tableName, chairNumber);
      return updated;
    });
  };

  // Clique sur table entière
  const handleTableClick = (tableIndex: number, tableName: string, tableStatus?: string, nbSeats?: number) => {
    if (tableStatus !== "0") return;

    const totalSeats = nbSeats || tableList[tableIndex].nbchair;
    const isSelected = selectedTables.includes(tableIndex);

    if (isSelected) {
      // DÉSELECTION
      setSelectedTables(prev => prev.filter(i => i !== tableIndex));
      const chairsByTable = tableSeats[tableIndex] || new Set<number>();

      setSelectedChairs(prev => {
        const updated = { ...prev };
        chairsByTable.forEach(n => delete updated[`${tableIndex}-${n}`]);
        return updated;
      });

      chairsByTable.forEach(n => removeItemFromPanier(tableName, n));

      setTableSeats(prev => {
        const updated = { ...prev };
        delete updated[tableIndex];
        return updated;
      });

    } else {
      // SÉLECTION
      setSelectedTables(prev => [...prev, tableIndex]);

      setSelectedChairs(prev => {
        const updated = { ...prev };
        const chairsByTable = new Set<number>();
        for (let n = 1; n <= totalSeats; n++) {
          const place = statePlaces.find(p => p.tableCode === tableName && Number(p.chairCode) === n);
          if (!place || place.status === "0") {
            const key = `${tableIndex}-${n}`;
            if (!prev[key]) {
              updated[key] = true;
              doValidCommande(tableName, n);
              chairsByTable.add(n);
            }
          }
        }
        setTableSeats(prev => ({ ...prev, [tableIndex]: chairsByTable }));
        return updated;
      });
    }
  };

  const getChairClass = (status?: string, isActive?: boolean) => {
    switch (status) {
      case "0": return isActive ? "blue-chair active" : "blue-chair available";
      case "1": return "blue-chair reserved";
      default: return "blue-chair disabled";
    }
  };

  const getTableClass = (tableIndex: number, tableStatus?: string) => {
    if (!tableStatus || tableStatus === "-1") return "blue-table-rect disabled";
    if (tableStatus === "1") return "blue-table-rect reserved";
    return selectedTables.includes(tableIndex) ? "blue-table-rect active" : "blue-table-rect available";
  };

  return (
    <div className="blue-cinema">
      <div className="blue-cinema-row">
        {tableList.map((tableBean, index) => {
          const tablePlaces = statePlaces.filter(p => p.tableCode === tableBean.table);
          const nbSeats = tablePlaces.length || tableBean.nbchair;
          const tableStatus = tablePlaces.length === 0 ? "-1" : tablePlaces[0].status;

          return (
            <div key={tableBean.table} className={`blue-table-wrapper ${tableStatus === "-1" ? "disabled" : ""}`}>
              <div className="blue-table-code">{tableBean.table}</div>

              <div className="blue-table-area">
                {/* LEFT CHAIRS */}
                <div className="blue-chairs">
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

                {/* TABLE */}
                <div
                  className={getTableClass(index, tableStatus)}
                  onClick={() => handleTableClick(index, tableBean.table, tableStatus, nbSeats)}
                />

                {/* RIGHT CHAIRS */}
                <div className="blue-chairs">
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
