import React, { useState, useEffect } from "react";
import { usePanier } from "../../../../states";
import "./RedSeatsRow.css";
import { EventBean, PlaceBean } from "../../../../states/stateModels";

interface RedSalonsProps {
  onCommande: (tableCode: string) => void;
  price: number;
  event: EventBean;
  statePlaces: PlaceBean[];
}

export default function RedSalons({
  onCommande,
  price,
  event,
  statePlaces,
}: RedSalonsProps) {

  const { items, addItem, removeItem } = usePanier();

  // Deux lignes
  const firstRow = Array.from({ length: 10 }, (_, i) => 14 + i);
  const secondRow = Array.from({ length: 10 }, (_, i) => 24 + i);

  const allSalons = [...firstRow, ...secondRow];

  const salonList = allSalons.map((num) => {
    const found = statePlaces.find(
      (p) => Number(p.tableCode) === num
    );
    return (
      found || {
        tableId: -1,
        tableCode: String(num),
        chairCode: "",
        status: "-1",
      }
    );
  });

  const [selectedSalons, setSelectedSalons] = useState<string[]>([]);

  // Charger localStorage
  useEffect(() => {
    const saved = localStorage.getItem("redSelectedSalons");
    if (saved) setSelectedSalons(JSON.parse(saved));
  }, []);

  // Sauvegarder localStorage
  useEffect(() => {
    localStorage.setItem(
      "redSelectedSalons",
      JSON.stringify(selectedSalons)
    );
  }, [selectedSalons]);

  // Reset si panier vide
  useEffect(() => {
    if (items.length === 0) {
      setSelectedSalons([]);
      localStorage.removeItem("redSelectedSalons");
    }
  }, [items]);

  const handleSalonClick = (
    status?: string,
    tableCode?: string
  ) => {
    if (status !== "0" || !tableCode) return;

    const isSelected = selectedSalons.includes(tableCode);

    if (isSelected) {
      setSelectedSalons((prev) =>
        prev.filter((code) => code !== tableCode)
      );

      items
        .filter((i) => i.tableNumber === tableCode)
        .forEach((i) => removeItem(i.id));
    } else {
      setSelectedSalons((prev) => [...prev, tableCode]);

      addItem({
        tableNumber: tableCode,
        chairNumber: undefined,
        price,
        name: "",
        quantity: 1,
        event,
      });

      onCommande(tableCode);
    }
  };

  const getSalonClass = (status?: string, tableCode?: string) => {
    if (status === "-1") return "red-salon disabled";
    if (status === "1") return "red-salon reserved";
    if (status === "0") {
      return selectedSalons.includes(tableCode!)
        ? "red-salon active"
        : "red-salon available";
    }
    return "red-salon disabled";
  };

  return (
    <div className="red-salons-container">

      {/* Ligne 1 */}
      <div className="red-salon-row">
        {salonList.slice(0, 10).map((salon) => (
          <div key={salon.tableCode} className="red-salon-wrapper">
            <div className="red-salon-code">
              {salon.tableCode}
            </div>
            <div
              className={getSalonClass(
                salon.status,
                salon.tableCode
              )}
              onClick={() =>
                handleSalonClick(
                  salon.status,
                  salon.tableCode
                )
              }
            />
          </div>
        ))}
      </div>

      {/* Ligne 2 */}
      <div className="red-salon-row">
        {salonList.slice(10, 20).map((salon) => (
          <div key={salon.tableCode} className="red-salon-wrapper">
            <div className="red-salon-code">
              {salon.tableCode}
            </div>
            <div
              className={getSalonClass(
                salon.status,
                salon.tableCode
              )}
              onClick={() =>
                handleSalonClick(
                  salon.status,
                  salon.tableCode
                )
              }
            />
          </div>
        ))}
      </div>

    </div>
  );
}

