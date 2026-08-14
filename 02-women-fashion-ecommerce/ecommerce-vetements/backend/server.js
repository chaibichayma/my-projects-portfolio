import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";

import authRoutes from "./routes/authRoutes.js"; 
import categoryRoutes from "./routes/categoryRoutes.js";
import shopRoutes from "./routes/shopRoutes.js";
import productRoutes, { clearExpiredOffers } from "./routes/productRoutes.js";

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URL)
  .then(() => console.log(" MongoDB connected"))
  .catch(err => console.log(" MongoDB connection error:", err));

app.use("/api/auth", authRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/products", productRoutes);
app.use("/api/shop", shopRoutes);
app.get("/", (req, res) => res.send("Server is running"));

setInterval(clearExpiredOffers, 60 * 1000);

app.listen(process.env.PORT, () => {
  console.log("Server running on port " + process.env.PORT);
});