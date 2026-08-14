import mongoose from "mongoose";

const shopSchema = new mongoose.Schema({
  productId: { type: mongoose.Schema.Types.ObjectId, ref: "Product", required: true },
  name: { type: String, required: true },
  surname: { type: String, required: true },
  phone: { type: String, required: true },
  email: { type: String, required: true },
  address: { type: String, required: true },
  region: { type: String, required: true },
  total: { type: Number, required: true }
}, { timestamps: true });

const Shop = mongoose.model("Shop", shopSchema);

export default Shop;