import React, { useState, useEffect } from "react";
import { usePanier } from "../../../../states";
import "./BlueSeat.css";
import { EventBean, PlaceBean } from "../../../../states/stateModels";

interface BlueSalonsProps {
  onCommande: (tableCode: string) => void;
  price: number;
  event: EventBean;
  statePlaces: PlaceBean[];
}

export default function BlueSalons({
  onCommande,
  price,
  event,
  statePlaces,
}: BlueSalonsProps) {

  const { items, addItem, removeItem } = usePanier();

  // Générer salons 52 → 63
  const salonNumbers = Array.from({ length: 12 }, (_, i) => 52 + i);

  const salonList = salonNumbers.map((num) => {
    const found = statePlaces.find(
      (p) => Number(p.tableCode) === num
    );
    return (
      found || {
        tableId: -1,
        tableCode: String(num),
        chairCode: "",
        status: "-1", // salon n'existe pas
      }
    );
  });

  const [selectedSalons, setSelectedSalons] = useState<string[]>([]);

  // Charger depuis localStorage
  useEffect(() => {
    const saved = localStorage.getItem("blueSelectedSalons");
    if (saved) setSelectedSalons(JSON.parse(saved));
  }, []);

  // Sauvegarder dans localStorage
  useEffect(() => {
    localStorage.setItem(
      "blueSelectedSalons",
      JSON.stringify(selectedSalons)
    );
  }, [selectedSalons]);

  // Si panier vide → reset salons
useEffect(() => {
  if (items.length === 0) {
    setSelectedSalons([]);
    localStorage.removeItem("blueSelectedSalons");
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

      // supprimer du panier
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
    if (status === "-1") return "blue-salon disabled";
    if (status === "1") return "blue-salon reserved";
    if (status === "0") {
      return selectedSalons.includes(tableCode!)
        ? "blue-salon active"
        : "blue-salon available";
    }
    return "blue-salon disabled";
  };

  return (
    <div className="blue-salons-container">
      {salonList.map((salon) => (
        <div key={salon.tableCode} className="blue-salon-wrapper">
          <div className="blue-salon-code">
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
  );
}
