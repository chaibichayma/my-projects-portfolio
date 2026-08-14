import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true, trim: true },
  price: { type: Number, required: true },
  discountPrice: { type: Number },
  discountPercent: { type: Number },
  images: [{ type: String }],
  marque: { type: String },
  offerStart: { type: Date },
  offerEnd: { type: Date },
  shippingPrice: { type: Number, default: 8.5 },
  categoryId: { type: mongoose.Schema.Types.ObjectId, ref: "Category" },
  comments: [
    {
      user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
      text: { type: String, required: true },
      createdAt: { type: Date, default: Date.now }
    }
  ],

}, { timestamps: true });

const Product = mongoose.model("Product", productSchema);
export default Product;