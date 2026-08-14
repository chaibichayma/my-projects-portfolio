import express from "express";
import Shop from "../models/Shop.js";

const router = express.Router();

router.post("/create", async (req, res) => {
  try {
    const { productId, name, surname, phone, email, address, region, total } = req.body;

    if (!productId || !name || !surname || !phone || !email || !address || !region || !total) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const newPurchase = new Shop({
      productId,
      name,
      surname,
      phone,
      email,
      address,
      region,
      total
    });

    await newPurchase.save();

    res.status(201).json({ message: "Purchase saved", purchase: newPurchase });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

export default router;