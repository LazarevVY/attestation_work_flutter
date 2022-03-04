# attestation_work_flutter

Итоговая аттестация

Минимально необходимое задание для выполнения итогового проекта:

В проекте Flutter реализовать страницу авторизации, содержащую поля для ввода номера телефона и пароля.
После нажатия на кнопку "Войти" сверять учётные данные с заранее заданными в исходном коде значениями.
При успешной авторизации перейти на главный экран. В случае ввода неверных данных вывести сообщение пользователю.
На главном экране приложения отобразить список пользователей, загруженный из сети по запросу
https://jsonplaceholder.typicode.com/users.
Для хранения данных пользователей создать класс User с полями, идентичными структуре ответа
https://jsonplaceholder.typicode.com/users/1.
В списке отобразить только основные данные пользователя - id, имя и email
При нажатии на пункт списка открыть экран с детальной информацией о пользователе,
а также отобразить список его задач, полученный по запросу
https://jsonplaceholder.typicode.com/todos?userId=1.
Элементы списка задач должны содержать флажки (checkbox), отмеченные в соответствии
со значением поля completed данной задачи.
Все экраны приложения (кроме экрана авторизации) должны иметь панели AppBar и NavigationDrawer,
содержащие кнопки для перехода между экранами
