import express from "express";
import Product from "../models/Product.js";

const router = express.Router();

router.get("/category/:id", async (req, res) => {
  try {
const now = new Date();
await Product.updateMany(
  { offerEnd: { $lt: now }, discountPrice: { $exists: true } },
  { $unset: { discountPrice: "", discountPercent: "" } }
);

    const products = await Product.find({ categoryId: req.params.id });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get("/:id", async (req, res) => {
  try {

    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.json(product);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export const clearExpiredOffers = async () => {
  const now = new Date();
  try {
    const result = await Product.updateMany(
      { offerEnd: { $lt: now }, discountPrice: { $exists: true } },
      { $unset: { discountPrice: "", discountPercent: "" } }
    );
    if (result.modifiedCount > 0) {
      console.log(`💡 Offres expirées mises à jour: ${result.modifiedCount} produit(s)`);
    }
  } catch (err) {
    console.log("❌ Erreur lors de la suppression des offres expirées:", err);
  }
};

router.post("/get-liked", async (req, res) => {
  const { productIds } = req.body; 

  try {
    if (!productIds || productIds.length === 0) {
      return res.status(400).json({ message: "No product IDs provided" });
    }

    const products = await Product.find({ _id: { $in: productIds } });
    res.json(products);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post("/get-cart-products", async (req, res) => {

  const { productIds } = req.body;

  try {

    const products = await Product.find({
      _id: { $in: productIds }
    });

    res.json(products);

  } catch (err) {
    res.status(500).json({ message: err.message });
  }

});

router.get("/:id/comments", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate("comments.user", "name");
    if (!product) return res.status(404).json({ message: "Produit non trouvé" });

    const formattedComments = product.comments.map(c => ({
      _id: c._id,
      userName: c.user.name, 
      text: c.text,
      createdAt: c.createdAt
    }));

    res.json(formattedComments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});


router.post("/:id/comment", async (req, res) => {
  const { userId, text } = req.body;

  if (!userId || !text) return res.status(400).json({ message: "Champs manquants" });

  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: "Produit non trouvé" });

    const comment = {
      user: userId,
      text,
      createdAt: new Date()
    };

    product.comments.unshift(comment); 
    await product.save();

    const user = await User.findById(userId);

    res.json({
      _id: comment._id,
      userName: user.name,
      text: comment.text,
      createdAt: comment.createdAt
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});
export default router;