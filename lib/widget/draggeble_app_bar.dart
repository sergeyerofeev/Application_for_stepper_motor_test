import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../provider/provider.dart';
import '../settings/key_store.dart' as key_store;

class DraggebleAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DraggebleAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isHidConnect = ref.watch(connectProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xB2F8F8F8),
        border: Border(
          top: BorderSide(
            color: Color(0xff707070),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          getAppBarTitle(),
          SizedBox(
            height: kWindowCaptionHeight,
            child: DragToResizeArea(
              enableResizeEdges: const [
                ResizeEdge.topLeft,
                ResizeEdge.top,
                ResizeEdge.topRight,
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 46,
                    height: kWindowCaptionHeight,
                    child: isHidConnect
                        ? const Icon(Icons.usb, size: 18.0, color: Colors.green)
                        : const Icon(Icons.usb_off, size: 18.0, color: Colors.red),
                  ),
                  WindowCaptionButton.minimize(
                    onPressed: () async {
                      bool isMinimized = await windowManager.isMinimized();
                      if (isMinimized) {
                        await windowManager.restore();
                      } else {
                        await windowManager.minimize();
                      }
                    },
                  ),
                  WindowCaptionButton.close(
                    onPressed: () async {
                      // Получим и сохраним положение окна на экране монитора
                      final position = await windowManager.getPosition();
                      final dx = await ref.read(storageProvider).get<double>(key_store.offsetX);
                      final dy = await ref.read(storageProvider).get<double>(key_store.offsetY);
                      // Сохраняем, только если значения изменились
                      if (dx != position.dx) {
                        await ref.read(storageProvider).set<double>(key_store.offsetX, position.dx);
                      }
                      if (dy != position.dy) {
                        await ref.read(storageProvider).set<double>(key_store.offsetY, position.dy);
                      }
                      // Проверяем на совпадение с сохранёным значением и если есть отличие  сохраняем
                      // в хранилище новые значения микро шага, направления вращения и угла шага двигателя
                      final oldMicroStep = await ref.read(storageProvider).get<int>(key_store.microStep);
                      final newMicroStep = ref.read(microStepProvider);
                      if (newMicroStep != oldMicroStep) {
                        await ref.read(storageProvider).set<int>(key_store.microStep, newMicroStep);
                      }
                      //
                      final oldDir = await ref.read(storageProvider).get<int>(key_store.dir);
                      final newDir = ref.read(directionProvider);
                      if (newDir != oldDir) {
                        await ref.read(storageProvider).set<int>(key_store.dir, newDir);
                      }
                      //
                      final oldStepAngle = await ref.read(storageProvider).get<int>(key_store.stepAngle);
                      final newStepAngle = ref.read(stepAngleProvider);
                      if (newStepAngle != oldStepAngle) {
                        await ref.read(storageProvider).set<int>(key_store.stepAngle, newStepAngle);
                      }

                      // Проверяем и сохраняем значения регистра PSC и выбранное, min, max значения регистра ARR
                      final oldPsc = await ref.read(storageProvider).get<int>(key_store.psc);
                      final newPsc = ref.read(pscProvider);
                      if (newPsc != oldPsc && ref.read(pscErrorProvider) == null) {
                        await ref.read(storageProvider).set<int>(key_store.psc, newPsc);
                      }
                      //
                      final oldArrMin = await ref.read(storageProvider).get<int>(key_store.arrMin);
                      final newArrMin = ref.read(arrMinProvider);
                      if (newArrMin != oldArrMin && ref.read(arrMinErrorProvider) == null) {
                        await ref.read(storageProvider).set<int>(key_store.arrMin, newArrMin);
                      }
                      //
                      final oldArrMax = await ref.read(storageProvider).get<int>(key_store.arrMax);
                      final newArrMax = ref.read(arrMaxProvider);
                      if (newArrMax != oldArrMax && ref.read(arrMaxErrorProvider) == null) {
                        await ref.read(storageProvider).set<int>(key_store.arrMax, newArrMax);
                      }
                      //
                      final oldCurrentArr = await ref.read(storageProvider).get<int>(key_store.currentArr);
                      final newCurrentArr = ref.read(currentArrProvider);
                      if (newCurrentArr != oldCurrentArr &&
                          ref.read(arrMinErrorProvider) == null &&
                          ref.read(arrMaxErrorProvider) == null) {
                        await ref.read(storageProvider).set<int>(key_store.currentArr, newCurrentArr);
                      }

                      // После всех сохранений закрываем приложение
                      await windowManager.close();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getAppBarTitle() {
    return DragToMoveArea(
      child: Container(
        height: kWindowCaptionHeight,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kWindowCaptionHeight);
}
