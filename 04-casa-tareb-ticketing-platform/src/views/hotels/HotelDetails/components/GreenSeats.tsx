import React, { useState, useEffect } from "react";
import "./GreenSeats.css";

import { usePanier } from "../../../../states";
import { EventBean, PlaceBean } from "../../../../states/stateModels";

interface GreenSalonsProps {
  onCommande: (tableCode: string) => void;
  price: number;
  event: EventBean;
  statePlaces: PlaceBean[];
}

export default function GreenSalons({
  onCommande,
  price,
  event,
  statePlaces,
}: GreenSalonsProps) {
  const { items, addItem, removeItem } = usePanier();

  // Générer salons 81 → 90 (une seule ligne)
  const salonNumbers = Array.from({ length: 10 }, (_, i) => 81 + i);

  const salonList = salonNumbers.map((num) => {
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

  // Charger depuis localStorage
  useEffect(() => {
    const saved = localStorage.getItem("greenSelectedSalons");
    if (saved) setSelectedSalons(JSON.parse(saved));
  }, []);

  // Sauvegarder dans localStorage
  useEffect(() => {
    localStorage.setItem(
      "greenSelectedSalons",
      JSON.stringify(selectedSalons)
    );
  }, [selectedSalons]);

  // Reset si panier vide
  useEffect(() => {
    if (items.length === 0) {
      setSelectedSalons([]);
      localStorage.removeItem("greenSelectedSalons");
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
    if (status === "-1") return "green-salon disabled";
    if (status === "1") return "green-salon reserved";
    if (status === "0") {
      return selectedSalons.includes(tableCode!)
        ? "green-salon active"
        : "green-salon available";
    }
    return "green-salon disabled";
  };

  return (
    <div className="green-salons-container">
      {salonList.map((salon) => (
        <div key={salon.tableCode} className="green-salon-wrapper">
          <div className="green-salon-code">
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
