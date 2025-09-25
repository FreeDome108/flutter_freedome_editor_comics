/// Поддерживаемые языки для комиксов
enum Cultures { en, ru, hi }

/// Вспомогательный класс для работы с языками
class CulturesHelper {
  static const List<Cultures> all = [Cultures.en, Cultures.ru, Cultures.hi];

  /// Получить индекс языка в списке
  static int indexOf(Cultures culture) {
    return all.indexOf(culture);
  }

  /// Получить язык по индексу
  static Cultures? getByIndex(int index) {
    if (index >= 0 && index < all.length) {
      return all[index];
    }
    return null;
  }
}
