import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class ManageMenuScreen extends StatelessWidget {
  final String? cafeId;

  const ManageMenuScreen({super.key, required this.cafeId});

  @override
  Widget build(BuildContext context) {
    if (cafeId == null || cafeId!.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('إدارة قائمة المنيو'),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'لم يتم العثور على كافيه مرتبط بهذا الحساب',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    final categoriesRef = FirebaseFirestore.instance
        .collection('cafes')
        .doc(cafeId)
        .collection('menuCategories');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'إدارة المنيو',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined, color: AppColors.textPrimary),
            tooltip: 'إضافة قسم جديد',
            onPressed: () => _showAddCategoryDialog(context, categoriesRef),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.textPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('إضافة صنف', style: TextStyle(color: Colors.white)),
        onPressed: () => _showItemDialog(context, categoriesRef),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoriesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('لا توجد تصنيفات منيو مضافة بعد'),
            );
          }

          final categories = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final catDoc = categories[index];
              final catData = catDoc.data() as Map<String, dynamic>;
              final catName = catData['name'] ?? catDoc.id;
              final items = List<Map<String, dynamic>>.from(catData['items'] ?? []);

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.textSecondary.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: items.isNotEmpty,
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEBE3D8),
                      child: Icon(Icons.coffee, color: AppColors.textPrimary),
                    ),
                    title: Text(
                      catName.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${items.length} أصناف',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note_outlined, color: AppColors.textPrimary, size: 22),
                          tooltip: 'تعديل اسم القسم',
                          onPressed: () => _showEditCategoryDialog(
                            context,
                            catDoc.reference,
                            catName.toString(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                          tooltip: 'حذف القسم بالكامل',
                          onPressed: () => _showDeleteCategoryDialog(
                            context,
                            catDoc.reference,
                            catName.toString(),
                          ),
                        ),
                        const Icon(Icons.expand_more),
                      ],
                    ),
                    children: [
                      if (items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'لا توجد عناصر مضافة داخل هذا القسم',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('أضف أول صنف هنا'),
                                onPressed: () => _showItemDialog(
                                  context,
                                  categoriesRef,
                                  preselectedCategoryDocId: catDoc.id,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (context, itemIdx) {
                            final item = items[itemIdx];
                            final itemName = item['name'] ?? '';
                            final itemPrice = item['price'] ?? 0;
                            final itemDesc = item['description'] ?? '';

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              title: Text(
                                itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: itemDesc.toString().isNotEmpty
                                  ? Text(
                                itemDesc.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              )
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$itemPrice ج.م',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 19),
                                    tooltip: 'تعديل الصنف',
                                    onPressed: () => _showItemDialog(
                                      context,
                                      categoriesRef,
                                      categoryDocId: catDoc.id,
                                      existingItem: item,
                                      itemIndex: itemIdx,
                                      currentItems: items,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 19, color: Colors.redAccent),
                                    tooltip: 'حذف الصنف',
                                    onPressed: () => _deleteItem(
                                      catDoc.reference,
                                      items,
                                      itemIdx,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditCategoryDialog(
      BuildContext context,
      DocumentReference categoryDocRef,
      String currentName,
      ) {
    final nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل اسم القسم'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'اسم القسم',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.textPrimary),
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                await categoryDocRef.update({'name': newName});
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ التعديل', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(
      BuildContext context,
      DocumentReference categoryDocRef,
      String categoryName,
      ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف القسم'),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف قسم "$categoryName" نهائياً؟ سيتم حذف جميع الأصناف التابعة له.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await categoryDocRef.delete();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(
      BuildContext context,
      CollectionReference categoriesRef,
      ) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة تصنيف جديد'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'مثلاً: مشروبات مثلجة، حلويات شرقية',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.textPrimary),
            onPressed: () async {
              final catName = nameController.text.trim();
              if (catName.isNotEmpty) {
                await categoriesRef.add({
                  'name': catName,
                  'items': [],
                });
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showItemDialog(
      BuildContext context,
      CollectionReference categoriesRef, {
        String? categoryDocId,
        String? preselectedCategoryDocId,
        Map<String, dynamic>? existingItem,
        int? itemIndex,
        List<Map<String, dynamic>>? currentItems,
      }) async {
    final isEditing = existingItem != null;
    final nameController = TextEditingController(text: existingItem?['name'] ?? '');
    final priceController = TextEditingController(
      text: existingItem != null ? existingItem['price'].toString() : '',
    );
    final descController = TextEditingController(text: existingItem?['description'] ?? '');

    String? selectedCatDocId = categoryDocId ?? preselectedCategoryDocId;

    final categoriesSnap = await categoriesRef.get();
    if (categoriesSnap.docs.isEmpty) return;

    if (selectedCatDocId == null && categoriesSnap.docs.isNotEmpty) {
      selectedCatDocId = categoriesSnap.docs.first.id;
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'تعديل صنف' : 'إضافة صنف جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isEditing) ...[
                  DropdownButtonFormField<String>(
                    value: selectedCatDocId,
                    decoration: const InputDecoration(
                      labelText: 'القسم التابع له',
                      border: OutlineInputBorder(),
                    ),
                    items: categoriesSnap.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(data['name'] ?? doc.id),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() => selectedCatDocId = val);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الصنف',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'السعر (ج.م)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.textPrimary),
              onPressed: () async {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? 0;
                final desc = descController.text.trim();

                if (name.isEmpty) return;

                final newItemData = {
                  'name': name,
                  'price': price,
                  'description': desc,
                };

                if (isEditing && categoryDocId != null && itemIndex != null && currentItems != null) {
                  currentItems[itemIndex] = newItemData;
                  await categoriesRef.doc(categoryDocId).update({'items': currentItems});
                } else if (selectedCatDocId != null) {
                  await categoriesRef.doc(selectedCatDocId).update({
                    'items': FieldValue.arrayUnion([newItemData]),
                  });
                }

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(isEditing ? 'حفظ' : 'إضافة', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(
      DocumentReference docRef,
      List<Map<String, dynamic>> items,
      int index,
      ) async {
    items.removeAt(index);
    await docRef.update({'items': items});
  }
}