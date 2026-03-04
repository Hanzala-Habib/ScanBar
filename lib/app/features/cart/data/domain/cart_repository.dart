import '../../../../core/db/app_database.dart';
import '../../../../core/models/cart_item.dart';

class CartRepository {
  CartRepository(this._database);

  final AppDatabase _database;

  Future<List<CartItem>> getAllItems() async {
    final db = await _database.database;
    final rows = await db.query(AppDatabase.cartItemsTable, orderBy: 'id ASC');
    return rows.map(CartItem.fromMap).toList();
  }

  Future<CartItem> upsertScannedItem(CartItem newItem) async {
    final db = await _database.database;

    final existing = await db.query(
      AppDatabase.cartItemsTable,
      where: 'barcode = ?',
      whereArgs: [newItem.barcode],
      limit: 1,
    );

    if (existing.isEmpty) {
      final id = await db.insert(AppDatabase.cartItemsTable, newItem.toMap()..remove('id'));
      return newItem.copyWith(id: id);
    }

    final current = CartItem.fromMap(existing.first);
    final updated = current.copyWith(quantity: current.quantity + 1);
    await db.update(
      AppDatabase.cartItemsTable,
      updated.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [current.id],
    );

    return updated;
  }

  Future<void> updateQuantity({required int id, required int quantity}) async {
    final db = await _database.database;
    if (quantity <= 0) {
      await db.delete(AppDatabase.cartItemsTable, where: 'id = ?', whereArgs: [id]);
      return;
    }

    await db.update(
      AppDatabase.cartItemsTable,
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearCart() async {
    final db = await _database.database;
    await db.delete(AppDatabase.cartItemsTable);
  }
}
