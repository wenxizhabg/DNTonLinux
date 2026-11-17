# Chủ đề 10. Cơ sở quản lý trạng thái và cập nhật giao diện trong Flutter

Nội dung nói + các bước code, đi theo mạch 4 video của kênh Flutter.

**Ký hiệu nguồn**

| Ký hiệu | Video | Link |
|---|---|---|
| V1 | How do I make my first Flutter app | https://www.youtube.com/watch?v=xWV71C2kp38 |
| V2 | What is State? | https://youtu.be/QlwiL_yLh6E |
| V4 | Stateful widgets in Flutter | https://youtu.be/Gzz8FwSlsUg |
| V3 | Managing State in Flutter | https://www.youtube.com/watch?v=vU9xDLdEZtU |

- `[V2 4:46–5:04]` = ý này video 2 nói ở mốc 4:46 đến 5:04.
- `[Bổ sung]` = không video nào nói, thêm vào để đủ yêu cầu của đề.
- **Nói:** là lời thuyết trình (viết lại bằng lời của mình, không dịch nguyên văn video). **Code:** là thao tác thêm/bớt code ngay lúc đó. **Chạy:** là thao tác demo.
- **Ví dụ:** là các ví dụ so sánh (analogy). Ví dụ lấy từ video thì ghi mốc thời gian; ví dụ ghi `[Bổ sung]` là mình nối dài ví dụ "công thức làm bánh" của video cho các ý video không nói.

**Bảng tra nhanh ví dụ so sánh (dùng xuyên suốt bài)**

| Trong ví dụ | Trong Flutter |
|---|---|
| Bộ đồ nghề có sẵn búa, tua vít | Flutter và các widget có sẵn |
| Sách → chương → đoạn → câu → từ | Cây widget: MaterialApp → Scaffold → AppBar → Text |
| Công thức làm bánh (không sửa khi đang làm) | Widget (bất biến) |
| Công thức lớn gồm các công thức con | Widget ghép từ widget nhỏ hơn |
| Số lát bánh đã bị lấy | State |
| Tờ ghi chú của người thợ, giữ suốt buổi | Object State |
| Bấm chuông báo bếp làm lại | `setState` |
| Tấm bảng chung của cả bếp | State đưa lên widget cha |

**Đối chiếu với đề**

| Yêu cầu của đề | Nằm ở |
|---|---|
| Khái niệm state, quan hệ state với giao diện | Phần 2 (bước 2.4) |
| StatelessWidget, StatefulWidget | Phần 1 (1.1), Phần 2 (2.5, 2.6), Phần 3 (3.1) |
| Vòng đời State và setState | Phần 3 (3.2 đến 3.5) |
| Trạng thái cục bộ và trạng thái cần chia sẻ | Phần 4 (4.1, 4.2) |
| Demo giao diện cập nhật theo state | Phần 2 (checkbox), Phần 4 (thanh progress) |
| Giải thích vòng đời cập nhật | Phần 3 (3.3), Phần 4 (4.4) |
| Giới hạn của quản lý trạng thái cục bộ | Phần 4 (4.6) |

---

## Phần 1. App ban đầu: toàn StatelessWidget (theo V1)

Mục tiêu: có một app chạy được, và một câu hỏi để mở bài: vì sao bấm checkbox không tick?

### 1.0 Flutter và widget qua hai ví dụ

**Ví dụ** `[V1 0:41–1:19]`: Flutter là một bộ đồ nghề để làm app. Khi xây nhà, không ai bắt đầu bằng việc tự chế ra cái búa hay cái tua vít; bộ đồ nghề đã có sẵn. Flutter cũng đưa sẵn những thứ nền tảng như vậy, gọi là widget: thanh tiêu đề, cột, nút bấm, icon, ô nhập chữ. Trong Flutter, mọi thứ đều là widget, và phần lớn widget lại được ghép từ widget khác.

**Ví dụ** `[V1 1:28–2:32]`: Hình dung việc viết một quyển sách. Sách gồm các chương, chương gồm các đoạn, đoạn gồm các câu, câu gồm các từ. Ta có một hệ phân cấp. Và hệ đó không cứng nhắc: một chương có thể mở đầu bằng câu trích dẫn, một câu có thể in nghiêng hay viết hoa. Widget giống như vậy: cùng những khối cơ bản, ghép và tùy biến theo cách khác nhau sẽ ra app khác nhau.

**Nói** `[V1 2:39–3:28]`: Lấy `AppBar` làm ví dụ. Nó không tự xử lý chữ mà giao cho widget `Text`. Đi xuống dưới thì widget càng chuyên biệt. Đi lên trên thì càng tổng quát: `AppBar` nằm trong `Scaffold`, `Scaffold` nằm trong `MaterialApp`.

### 1.1 Điểm bắt đầu: main, runApp, widget đầu tiên

**Nói** `[V1 6:45–7:20]`: File nguồn chính của một app Flutter bắt đầu bằng hai thứ: phần import và hàm `main`. `main` chỉ làm một việc là gọi `runApp`. Widget truyền vào `runApp` trở thành gốc của cây widget.

**Nói** `[V1 7:55–8:16]`: Để tự tạo một widget, ta viết một class kế thừa `StatelessWidget`. Class này bắt buộc có hàm `build`, trả về một `Widget` khác. Nghĩa là mỗi widget được mô tả bằng các widget nhỏ hơn. Chữ "stateless" nghĩa là gì thì Phần 2 sẽ trả lời.

**Code:**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exploration',
      home: MyHomePage(),
    );
  }
}
```

### 1.2 Thêm trang chính

**Nói** `[V1 8:21–8:55]`: `MaterialApp` nằm trên cùng, trang chính tách thành một widget riêng. Trong trang chính, `Scaffold` cho sẵn khung của một màn hình: thanh tiêu đề và phần thân. Phần thân là một `Column` gồm hai nhóm ngang hàng: phần tiến độ và danh sách việc cần làm.

**Code (thêm):**

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Space exploration')),
      body: const Column(
        children: [
          Progress(),
          TaskList(),
        ],
      ),
    );
  }
}
```

### 1.3 Thêm Progress

**Nói** `[V1 8:55–9:08]`: `Progress` gồm một dòng chữ và một `LinearProgressIndicator` bên dưới. Giá trị thanh tiến độ tạm thời ghi cứng bằng 0.

**Code (thêm):**

```dart
class Progress extends StatelessWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('You are this far away from exploring the whole universe'),
        LinearProgressIndicator(value: 0.0),
      ],
    );
  }
}
```

### 1.4 Thêm TaskList và TaskItem

**Nói** `[V1 9:08–9:26]`: `TaskList` là một `Column` chứa các `TaskItem`. Để dùng lại được, `TaskItem` nhận nhãn qua tham số `label`. Bản thân nó là một `Row` gồm `Checkbox` và `Text`. Hai tham số bắt buộc của `Checkbox` tạm ghi cứng cho chạy được.

**Code (thêm):**

```dart
class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TaskItem(label: 'Load the rocket with supplies'),
        TaskItem(label: 'Launch the rocket'),
        TaskItem(label: 'Circle the home planet'),
        TaskItem(label: 'Head out to the first moon'),
        TaskItem(label: 'Launch moon lander #1'),
      ],
    );
  }
}

class TaskItem extends StatelessWidget {
  final String label;

  const TaskItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (newValue) {}),
        Text(label),
      ],
    );
  }
}
```

**Chạy:** bấm vào checkbox. Không có gì xảy ra.

**Nói** `[V1 10:10–10:17]`: App đã lên hình, nhưng để lại hai câu hỏi. "State" trong chữ stateless là gì? Và vì sao bấm checkbox mà nó không tick?

---

## Phần 2. State là gì, từ Stateless sang Stateful (theo V2)

Mục tiêu: trả lời hai câu hỏi cuối Phần 1, làm cho checkbox tick được.

### 2.1 Widget không bao giờ thay đổi

**Nói** `[V2 0:26–0:52]`: Ở Phần 1, widget được ví với quyển sách: `MaterialApp` giống cả quyển sách, tự nó không làm gì nhưng định ra chủ đề cho toàn bộ app. Ví dụ đó chưa trọn vẹn, vì tài liệu Flutter còn nói thêm một điều: widget chỉ là bản mô tả cho một phần giao diện, và bản mô tả đó bất biến. Bất biến nghĩa là sao? Cần một ví dụ khác.

**Ví dụ** `[V2 1:00–2:07]`: Giả sử cần làm một chiếc bánh kem nhiều tầng. Ta không lao vào làm ngay mà lên kế hoạch và gom công thức. Công thức lớn lại gồm nhiều công thức con: một cho cốt bánh, một cho lớp kem, một cho phần trang trí. Và trong lúc làm, ta không sửa công thức; ta làm đúng từng bước như đã viết, để lần nào cũng ra đúng chiếc bánh đó. Widget giống các công thức này. Nó không phải là một phần của app đang chạy; nó mô tả chính xác cách dựng phần đó, và mỗi lần dựng ta làm đúng theo mô tả, không sửa gì.

**Nói** `[V2 2:07–2:28]`: Nhìn vào code sẽ thấy đúng như vậy: field `label` là `final`, constructor là `const`. Tạo xong thì không sửa được nữa. Ta dùng widget để khai báo app trông như thế nào, phần còn lại Flutter lo. Nhưng giao diện thì phải thay đổi khi người dùng thao tác. Vậy làm sao thay đổi một thứ được định nghĩa là không đổi?

### 2.2 Đọc lại dòng Checkbox

**Nói** `[V2 3:03–3:48]`: Hai tham số của `Checkbox` quyết định hành vi của nó. `value` là kiểu bool, cho biết ô có đang tick không. `onChanged` là hàm được gọi khi người dùng bấm. Code hiện tại ghi `value: false` và `onChanged` rỗng. Giao diện đang chạy đúng theo mô tả: bấm vào thì không làm gì, và luôn luôn không tick.

### 2.3 Thử sửa lần 1: đưa value vào một biến

**Nói** `[V2 3:48–4:10]`: Cách sửa dễ nghĩ tới nhất: đưa `value` vào một biến, trong `onChanged` gán giá trị mới cho biến đó. Theo quy ước Dart, biến nội bộ bắt đầu bằng dấu gạch dưới.

**Code (sửa TaskItem):**

```dart
class TaskItem extends StatelessWidget {
  final String label;
  bool _value = false;                                  // thêm

  TaskItem({super.key, required this.label});           // phải bỏ const

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _value,                                // sửa
          onChanged: (newValue) {
            _value = newValue ?? false;                 // sửa
          },
        ),
        Text(label),
      ],
    );
  }
}
```

Lưu ý khi demo: bỏ thêm `const` trước `Column` trong `TaskList` thì mới biên dịch được.

**Chạy:** bấm checkbox. Vẫn không tick.

**Nói** `[V2 4:10–4:32]`: Trình soạn thảo gạch chân class này. Thông báo nói rằng class được đánh dấu là bất biến nhưng lại có field không `final`. Thông báo đó cùng ý với định nghĩa ở 2.1: biến trong class widget không được phép thay đổi.

**Nói** `[Bổ sung]`: Lý do nó không chạy: `onChanged` có gán `_value = true` thật, nhưng không ai gọi lại `build`, nên màn hình vẫn là kết quả của lần `build` trước.

**Ví dụ** `[Bổ sung]`: Việc vừa làm giống như lấy bút sửa thẳng vào tờ công thức sau khi bánh đã ra lò. Tờ giấy có đổi, nhưng chiếc bánh trên bàn vẫn y nguyên, vì không ai làm lại bánh theo tờ giấy đã sửa.

### 2.4 Khái niệm state

**Ví dụ** `[V2 4:39–4:46]`: Quay lại chiếc bánh. Có nên báo "bánh sắp hết" hay không thì không ghi trong công thức; nó phụ thuộc vào số lát đã bị lấy đi tính đến lúc này.

**Nói** `[V2 4:32–5:04]`: Widget thì không đổi, nhưng giao diện phải phụ thuộc vào những gì người dùng đã làm, giống như số lát bánh đã lấy. Phần dữ liệu đó gọi là state. Định nghĩa: **state là mọi dữ liệu cần có để dựng giao diện tại một thời điểm**. Với checkbox, state là một giá trị bool: ô này có đang tick hay không.

**Nói** `[Bổ sung]`: Quan hệ giữa state và giao diện viết gọn là `UI = build(state)`. Ta không ra lệnh "tick ô này". Ta đổi state, rồi `build` chạy lại và trả về giao diện ứng với state mới.

### 2.5 Sửa lần 2: chuyển sang StatefulWidget và gọi setState

**Nói** `[V2 5:04–5:31]`: Mọi widget từ đầu đến giờ đều là stateless, tức là không cần state. `TaskItem` thì cần. Trình soạn thảo làm giúp việc chuyển đổi: đặt con trỏ vào tên class, mở quick action (VS Code: `Ctrl + .`), chọn "Convert to StatefulWidget".

**Nói** `[V2 5:31–5:43]`: Còn một chỗ phải tự sửa: báo cho Flutter biết state đã đổi. Ta bọc phép gán trong `setState`. `setState` nhận một hàm, trong hàm đó ta thực hiện thay đổi.

**Code (TaskItem sau khi chuyển):**

```dart
class TaskItem extends StatefulWidget {
  final String label;

  const TaskItem({super.key, required this.label});     // const quay lại

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _value = false;                                  // state nằm ở đây

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _value,
          onChanged: (newValue) {
            setState(() {                               // thêm
              _value = newValue ?? false;
            });
          },
        ),
        Text(widget.label),                             // label -> widget.label
      ],
    );
  }
}
```

**Chạy** `[V2 5:46]`: restart app (hot restart, vì kiểu của widget đã đổi). Bấm checkbox: tick được.

### 2.6 Cái gì đổi, cái gì không

**Nói** `[V2 5:52–6:31]`: So với bản cũ, nội dung hàm `build` gần như giữ nguyên, chỉ khác chỗ lấy nhãn: `widget.label`. Thứ thay đổi là vị trí của `build`: nó chuyển từ class widget sang class State. Nhờ vậy class widget vẫn bất biến (toàn `final`, constructor `const`), còn biến `_value` nằm trong object State, tồn tại qua các lần build, và giao diện được dựng từ nó.

---

## Phần 3. Bên trong StatefulWidget: hai class, vòng đời State, setState (theo V4)

Mục tiêu: hiểu vì sao cách sửa ở Phần 2 chạy được. Video 4 dùng ví dụ `MyCheckbox`; ở đây áp các ý đó lên `TaskItem`.

### 3.1 Một StatefulWidget gồm hai class

**Ví dụ** `[V4 0:39–1:00]`: Video 4 dùng lại hình ảnh công thức, nhưng nói rõ hơn: widget là tờ công thức dùng một lần. Nó chỉ cho Flutter cách vẽ màn hình ở frame hiện tại. Frame sau nếu có tờ công thức khác thì Flutter vẽ theo tờ mới. Tờ công thức không bị sửa, nó bị thay bằng tờ khác. Nên câu hỏi đúng không phải "sửa widget thế nào" mà là "báo cho Flutter có công thức mới bằng cách nào".

**Ví dụ** `[Bổ sung]`: Nếu công thức bị thay liên tục thì số lát bánh đã lấy ghi ở đâu? Ghi trên một tờ ghi chú riêng của người thợ. Tờ công thức in lại bao nhiêu lần cũng được, còn tờ ghi chú thì người thợ giữ suốt buổi và chỉ có một tờ. Tờ ghi chú đó là object State.

**Nói** `[V4 1:00–1:40]`: StatefulWidget gồm hai class. Class thứ nhất là widget (`TaskItem`): nhẹ, bất biến, bị thay liên tục. Class thứ hai là State (`_TaskItemState`): thay đổi được, sống lâu, được dùng lại qua nhiều lần build. Widget giao hàm `build` cho State. Object State có hai nhiệm vụ: giữ dữ liệu thay đổi theo thời gian, và báo cho Flutter khi dữ liệu đó đổi.

**Nói** `[V4 1:40–1:51]`: Để làm hai việc đó, State có một số hàm. Bốn hàm cần biết trước: `initState`, `setState`, `dispose`, và `build`.

### 3.2 initState

**Nói** `[V4 1:51–2:24]`: `initState` được framework gọi đúng một lần, khi object State được tạo. Đây là chỗ khởi tạo những thứ widget cần, nhất là khi phải dùng dữ liệu được truyền vào widget. Không khởi tạo trong constructor của State, vì lúc đó State chưa được gắn với widget, chưa đọc được `widget.xxx`.

**Code (thêm tham số `initialValue`, thêm `initState`):**

```dart
class TaskItem extends StatefulWidget {
  final String label;
  final bool initialValue;                              // thêm

  const TaskItem({
    super.key,
    required this.label,
    this.initialValue = false,                          // thêm
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _value;                                     // sửa: bỏ "= false"

  @override
  void initState() {                                    // thêm
    super.initState();
    _value = widget.initialValue;
    debugPrint('initState  ${widget.label}');
  }

  // build giữ nguyên
}
```

Trong `TaskList`, sửa dòng đầu: `TaskItem(label: 'Load the rocket with supplies', initialValue: true),`

**Chạy:** restart. Ô đầu tiên tick sẵn. Console in 5 dòng `initState`, mỗi `TaskItem` một dòng, và chỉ in một lần.

### 3.3 setState và vòng đời cập nhật

**Nói** `[V4 2:24–2:49]`: Khi người dùng bấm, ta đổi biến `_value`, và phải báo cho Flutter dựng lại phần giao diện này. Việc báo đó là `setState`. Nếu chỉ đổi biến mà không gọi `setState` thì màn hình không đổi, vì Flutter không biết là cần build lại.

**Code (thử bỏ setState):**

```dart
onChanged: (newValue) {
  _value = newValue ?? false;        // tạm bỏ setState
  debugPrint('_value = $_value');
},
```

**Chạy:** bấm checkbox. Console in `_value = true`, nhưng ô không tick. Trả `setState` lại như cũ.

**Ví dụ** `[Bổ sung]`: `setState` giống việc người thợ sửa tờ ghi chú rồi bấm chuông báo bếp: "ghi chú đã đổi, làm lại phần này". Lần thử vừa rồi là sửa ghi chú mà không bấm chuông: con số trên giấy đã khác, nhưng không ai trong bếp biết để làm lại.

**Nói** `[Bổ sung]`: Bên trong, một lần cập nhật đi qua 4 bước:

1. `setState(fn)` chạy `fn` ngay lập tức, nên `_value` đổi ngay.
2. `setState` đánh dấu phần tử của widget này trong cây là "dirty" (cần build lại) và xin framework một frame mới. Nó không vẽ gì ngay tại đây.
3. Ở frame kế tiếp, framework gọi `build()` của đúng những State bị đánh dấu.
4. Framework so cây widget mới với cây cũ, cập nhật phần khác nhau, rồi vẽ.

**Code (thêm log vào đầu các hàm build):**

```dart
// trong Progress.build
debugPrint('build Progress');

// trong _TaskItemState.build
debugPrint('build      ${widget.label}');
```

Lưu ý: `Progress.build` đang `return const Column(...)`, thêm lệnh `debugPrint` phía trên `return` là được.

**Chạy:** bấm một ô. Console chỉ in một dòng `build` của đúng `TaskItem` đó. `Progress` và 4 ô còn lại không build lại.

**Nói** `[Bổ sung]`: Phạm vi build lại của `setState` là State gọi nó và các widget con bên dưới. Ghi nhớ điểm này, Phần 4 sẽ dùng lại.

### 3.4 dispose

**Nói** `[V4 2:49–3:00]`: `dispose` được gọi khi object State bị gỡ hẳn khỏi cây widget. Đây là chỗ dọn những thứ đã khởi tạo trong `initState`, ví dụ dừng và giải phóng `AnimationController`.

**Code (thêm `dispose` vào `_TaskItemState`):**

```dart
@override
void dispose() {
  debugPrint('dispose    ${widget.label}');
  super.dispose();
}
```

**Code (để gỡ được `TaskItem` khỏi cây, tạm chuyển `TaskList` sang Stateful, thêm nút ẩn/hiện):**

```dart
class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: Text(_visible ? 'Ẩn danh sách' : 'Hiện danh sách'),
        ),
        if (_visible) ...const [
          TaskItem(label: 'Load the rocket with supplies', initialValue: true),
          TaskItem(label: 'Launch the rocket'),
          TaskItem(label: 'Circle the home planet'),
          TaskItem(label: 'Head out to the first moon'),
          TaskItem(label: 'Launch moon lander #1'),
        ],
      ],
    );
  }
}
```

**Chạy:** tick thêm vài ô, bấm "Ẩn danh sách". Console in 5 dòng `dispose`. Bấm "Hiện danh sách": in lại 5 dòng `initState`, và các ô vừa tick đã mất, chỉ còn ô đầu (do `initialValue`).

**Ví dụ** `[Bổ sung]`: Người thợ rời bếp thì mang theo tờ ghi chú và bỏ nó đi. Người thợ mới vào thay sẽ bắt đầu bằng một tờ trắng.

**Nói** `[Bổ sung]`: State cục bộ sống và chết cùng vị trí của widget trong cây. Widget bị gỡ thì State bị hủy, dữ liệu trong nó mất theo. Đây là giới hạn đầu tiên của state cục bộ.

### 3.5 Tổng kết vòng đời State

**Nói** `[V4 3:14–3:24]`: Widget là bản mô tả bất biến. Object State giữ dữ liệu thay đổi theo thời gian. `setState` là cách báo cho Flutter rằng có thay đổi và cần build lại.

**Nói** `[Bổ sung]`: Thứ tự đầy đủ các hàm trong vòng đời của một State:

```
createState          widget tạo ra object State
   ↓
initState            một lần duy nhất
   ↓
didChangeDependencies
   ↓
build  ←───────────┐
   ↓               │
setState ──────────┤  state của chính nó đổi
didUpdateWidget ───┘  cha build lại và truyền widget mới xuống (xem 4.4)
   ↓
deactivate → dispose  bị gỡ khỏi cây
```

---

## Phần 4. State cục bộ và state cần chia sẻ, giới hạn của state cục bộ (theo V3)

Mục tiêu: làm cho thanh progress chạy theo checkbox bằng cách cơ sở nhất (đưa state lên widget cha), rồi chỉ ra giới hạn.

### 4.1 Vấn đề: thanh progress đứng yên

**Chạy** `[V3 0:00–0:19]`: tick vài ô. Checkbox đã hoạt động, nhưng thanh progress phía trên không nhúc nhích.

**Nói** `[V3 0:19–0:53]`: Nhắc lại hai ý đã có: widget bất biến, nó không phải app mà là công thức mô tả cách dựng app; và state là dữ liệu quyết định giao diện trông ra sao khi người dùng thao tác.

**Ví dụ** `[Bổ sung]`: Trong bếp bây giờ có 5 người thợ, mỗi người giữ một tờ ghi chú riêng trong túi. Người đứng ở quầy cần báo "đã xong bao nhiêu phần" nhưng không đọc được tờ nào trong số đó.

**Nói** `[V3 0:53–1:24]`: Nhìn code sẽ thấy lý do. `Progress` không có state nào. State của từng checkbox được cất riêng trong từng `_TaskItemState`. Vậy làm sao `Progress` biết được state của các `TaskItem`? Hiện tại thì không có cách nào: `_value` là biến riêng của `_TaskItemState`, còn `Progress` nằm ở nhánh khác của cây.

### 4.2 Phân biệt state cục bộ và state cần chia sẻ

**Nói** `[Bổ sung]`: Có hai loại state.

- **State cục bộ**: chỉ một widget cần. Ví dụ: ô nào đang tick khi chưa ai khác quan tâm, tab đang chọn, nội dung đang gõ trong một ô nhập. Cất trong State của chính widget đó và dùng `setState` là đủ.
- **State cần chia sẻ**: từ hai widget trở lên cùng cần. Ở đây trạng thái tick của các task vừa quyết định hình dạng checkbox, vừa quyết định giá trị thanh progress.

Câu hỏi để phân loại: **ai cần đọc dữ liệu này?** Một widget thì cục bộ. Nhiều widget thì phải chia sẻ. Cùng một dữ liệu có thể đổi loại khi app thêm yêu cầu: ở Phần 2, `_value` là cục bộ; khi có thanh progress, nó trở thành state cần chia sẻ.

**Nói** `[V3 1:30–2:03]`: Nếu state là dữ liệu quyết định giao diện, thì quản lý state là cách tổ chức app để truy cập state và chia sẻ nó giữa các widget. Quản lý state có hai mục tiêu: một, cho các widget truy cập được dữ liệu; hai, báo cho widget build lại khi dữ liệu đổi.

### 4.3 Đưa state lên widget cha chung

**Nói** `[V3 2:37–2:46]`: Muốn `Progress` biết state của các task, ta đưa state đó lên cao hơn trong cây widget, tới chỗ mà cả `Progress` lẫn `TaskList` đều nhận được. Video 3 làm việc này bằng package Riverpod. Ở đây làm bằng công cụ cơ sở đã học: `setState`. Cha chung gần nhất của `Progress` và `TaskList` là `MyHomePage`.

**Ví dụ** `[Bổ sung]`: Thay vì mỗi thợ giữ ghi chú riêng, cả bếp dùng một tấm bảng chung treo ở chỗ bếp trưởng. Thợ nào xong việc thì báo bếp trưởng ghi lên bảng. Người ở quầy nhìn bảng là biết tiến độ.

**Code bước 1 (thêm class `Task`)** `[V3 4:28]`:

```dart
class Task {
  final String label;
  bool isDone;

  Task(this.label, {this.isDone = false});
}
```

**Code bước 2 (`MyHomePage` thành Stateful, giữ danh sách task):**

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [
    Task('Load the rocket with supplies', isDone: true),
    Task('Launch the rocket'),
    Task('Circle the home planet'),
    Task('Head out to the first moon'),
    Task('Launch moon lander #1'),
  ];

  void _toggle(int index, bool value) {
    setState(() {
      _tasks[index].isDone = value;
    });
  }

  void _clearAll() {
    setState(() {
      for (final task in _tasks) {
        task.isDone = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build MyHomePage');
    final done = _tasks.where((task) => task.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Space exploration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Bỏ chọn tất cả',
            onPressed: _clearAll,
          ),
        ],
      ),
      body: Column(
        children: [
          Progress(value: done / _tasks.length),
          TaskList(tasks: _tasks, onToggle: _toggle),
        ],
      ),
    );
  }
}
```

**Code bước 3 (`Progress` nhận giá trị từ cha):**

```dart
class Progress extends StatelessWidget {
  final double value;                                   // thêm

  const Progress({super.key, required this.value});     // sửa

  @override
  Widget build(BuildContext context) {
    debugPrint('build Progress');
    return Column(
      children: [
        const Text('You are this far away from exploring the whole universe'),
        LinearProgressIndicator(value: value),          // sửa: hết ghi cứng
      ],
    );
  }
}
```

**Code bước 4 (`TaskList` về lại Stateless, duyệt danh sách)** `[V3 4:53–5:05]`: bỏ nút ẩn/hiện và 5 dòng ghi cứng, thay bằng vòng lặp trên danh sách task.

```dart
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int index, bool value) onToggle;

  const TaskList({super.key, required this.tasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    debugPrint('build TaskList');
    return Column(
      children: [
        for (var i = 0; i < tasks.length; i++)
          TaskItem(
            label: tasks[i].label,
            value: tasks[i].isDone,
            onChanged: (value) => onToggle(i, value),
          ),
      ],
    );
  }
}
```

**Code bước 5 (`TaskItem` nhận `value` và `onChanged`, tạm thời vẫn là Stateful):**

```dart
class TaskItem extends StatefulWidget {
  final String label;
  final bool value;                                     // thay initialValue
  final ValueChanged<bool> onChanged;                   // thêm

  const TaskItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;                              // chép giá trị từ cha
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build      ${widget.label}');
    return Row(
      children: [
        Checkbox(
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue ?? false;
            });
            widget.onChanged(_value);                   // thêm: báo lên cha
          },
        ),
        Text(widget.label),
      ],
    );
  }
}
```

**Chạy:** restart. Tick từng ô: thanh progress chạy theo. Đây là demo "giao diện cập nhật theo thay đổi trạng thái" với state được chia sẻ.

### 4.4 Lỗi hai bản sao state và didUpdateWidget

**Chạy:** tick vài ô, rồi bấm nút refresh "Bỏ chọn tất cả" trên thanh tiêu đề. Thanh progress về 0, nhưng các checkbox vẫn tick. Giao diện đang mâu thuẫn với dữ liệu.

**Nói** `[Bổ sung]`: Nguyên nhân: cùng một dữ liệu đang có hai bản. Bản chính là `isDone` ở `_MyHomePageState`. Bản chép là `_value` trong mỗi `_TaskItemState`, chép một lần duy nhất ở `initState`. Khi cha build lại, nó tạo ra các widget `TaskItem` mới với `value: false`. Nhưng framework thấy widget mới cùng kiểu, cùng vị trí với widget cũ, nên giữ nguyên object State cũ và chỉ gắn widget mới vào. `initState` không chạy lại, `_value` vẫn là giá trị cũ.

**Nói** `[Bổ sung]`: Đúng thời điểm đó framework gọi một hàm khác trong vòng đời: `didUpdateWidget`.

**Code (thêm vào `_TaskItemState` để quan sát):**

```dart
@override
void didUpdateWidget(covariant TaskItem oldWidget) {
  super.didUpdateWidget(oldWidget);
  debugPrint(
    'didUpdateWidget ${widget.label}: '
    'widget mới = ${!identical(oldWidget, widget)}, '
    'State = ${identityHashCode(this)}',
  );
  _value = widget.value;                                // chép lại giá trị mới
}
```

**Chạy:** bấm "Bỏ chọn tất cả". Checkbox giờ bỏ tick đúng. Console cho thấy `widget mới = true` còn mã `State` của mỗi ô không đổi qua các lần bấm. Hai dòng log này là bằng chứng cho ý ở 3.1: widget bị thay, State sống tiếp.

### 4.5 Sửa gọn: TaskItem không giữ state nữa

**Nói** `[Bổ sung]`: `didUpdateWidget` sửa được lỗi, nhưng vẫn còn hai bản sao của một dữ liệu. Cách gọn hơn: mỗi dữ liệu chỉ có một nơi giữ. Trạng thái tick đã nằm ở `_MyHomePageState`, vậy `TaskItem` không cần State nữa. Nó quay về StatelessWidget: hiển thị `value` nhận từ cha, và khi bị bấm thì gọi `onChanged` để cha tự đổi state.

**Code (`TaskItem` bản cuối, xóa hẳn `_TaskItemState`):**

```dart
class TaskItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const TaskItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('build      $label');
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (newValue) => onChanged(newValue ?? false),
        ),
        Text(label),
      ],
    );
  }
}
```

**Chạy:** restart. Tick, bỏ tick, "Bỏ chọn tất cả": checkbox và thanh progress luôn khớp nhau.

**Nói** `[Bổ sung]`: Dữ liệu đi một chiều từ trên xuống qua tham số constructor. Sự kiện đi từ dưới lên qua callback. State nằm ở một chỗ duy nhất.

### 4.6 Giới hạn của cách quản lý state bằng setState

**Chạy:** xóa console, tick đúng một ô, đọc log.

```
build MyHomePage
build Progress
build TaskList
build      Load the rocket with supplies
build      Launch the rocket
build      Circle the home planet
build      Head out to the first moon
build      Launch moon lander #1
```

**Nói** `[Bổ sung]`: So với 3.3, lúc đó tick một ô chỉ build lại một `TaskItem`. Bây giờ tick một ô thì build lại cả trang. Từ demo này rút ra ba giới hạn:

1. **Phạm vi build lại rộng.** `setState` build lại State gọi nó và mọi thứ bên dưới. State càng đưa lên cao, mỗi thay đổi nhỏ càng kéo theo nhiều widget build lại.
2. **Phải chuyền dữ liệu qua từng tầng.** `TaskList` không dùng `onToggle`, nó chỉ nhận rồi chuyền tiếp cho `TaskItem`. Cây sâu thêm một tầng là thêm một lần chuyền, qua cả những widget không liên quan.
3. **State gắn với vị trí trong cây.** Như 3.4 đã thấy, widget bị gỡ thì state mất. Nếu thêm một màn hình thứ hai cũng cần danh sách task, state lại phải đưa lên cao hơn nữa, tới `MainApp`, và hai giới hạn trên nặng thêm.

**Ví dụ** `[Bổ sung]`: Tấm bảng chung có cái giá của nó. Mỗi lần bảng đổi một dòng, bếp trưởng phát lại công thức cho cả bếp (giới hạn 1). Thợ không được tự viết lên bảng mà phải nhờ tổ trưởng chuyền lời lên bếp trưởng, dù tổ trưởng không liên quan gì đến việc đó (giới hạn 2). Và bếp bên cạnh muốn xem thì bảng phải dời lên chỗ quản lý nhà hàng (giới hạn 3).

**Nói** `[V3 1:41–2:31]`: Quản lý state là chủ đề có rất nhiều giải pháp, không có một giải pháp tốt nhất cho mọi trường hợp.

**Nói** `[V3 2:52–4:19, 4:38–5:17]`: Hướng đi mà video 3 chọn là Riverpod. Ý tưởng: state được chuyển ra khỏi widget, đặt vào một đối tượng gọi là provider. Widget nào cần thì đăng ký theo dõi provider đó. Khi state đổi, chỉ những widget đang theo dõi được build lại, và widget ở bất kỳ đâu trong cây cũng truy cập được mà không cần chuyền qua từng tầng. Nó giải quyết đúng ba giới hạn vừa nêu. Phần này vượt ra ngoài "cơ sở" nên chỉ dừng ở mức giới thiệu.

### 4.7 Kết bài

**Nói:** Tóm lại 4 ý:

1. State là dữ liệu cần để dựng giao diện tại một thời điểm; giao diện là kết quả của `build` trên state.
2. Widget bất biến. StatefulWidget tách thành hai class để phần dữ liệu thay đổi nằm trong object State sống lâu.
3. Vòng đời State: `initState` một lần, `build` nhiều lần, `setState` để yêu cầu build lại, `didUpdateWidget` khi cha truyền widget mới, `dispose` khi bị gỡ.
4. State cục bộ thì để trong widget. State cần chia sẻ thì đưa lên cha chung. Cách này có giới hạn về phạm vi build lại, việc chuyền dữ liệu qua nhiều tầng, và sự phụ thuộc vào vị trí trong cây; đó là lý do các thư viện quản lý state ra đời.

---

## Phụ lục: `lib/main.dart` ở trạng thái cuối bài

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class Task {
  final String label;
  bool isDone;

  Task(this.label, {this.isDone = false});
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exploration',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [
    Task('Load the rocket with supplies', isDone: true),
    Task('Launch the rocket'),
    Task('Circle the home planet'),
    Task('Head out to the first moon'),
    Task('Launch moon lander #1'),
  ];

  void _toggle(int index, bool value) {
    setState(() {
      _tasks[index].isDone = value;
    });
  }

  void _clearAll() {
    setState(() {
      for (final task in _tasks) {
        task.isDone = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build MyHomePage');
    final done = _tasks.where((task) => task.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Space exploration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Bỏ chọn tất cả',
            onPressed: _clearAll,
          ),
        ],
      ),
      body: Column(
        children: [
          Progress(value: done / _tasks.length),
          TaskList(tasks: _tasks, onToggle: _toggle),
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  final double value;

  const Progress({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    debugPrint('build Progress');
    return Column(
      children: [
        const Text('You are this far away from exploring the whole universe'),
        LinearProgressIndicator(value: value),
      ],
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int index, bool value) onToggle;

  const TaskList({super.key, required this.tasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    debugPrint('build TaskList');
    return Column(
      children: [
        for (var i = 0; i < tasks.length; i++)
          TaskItem(
            label: tasks[i].label,
            value: tasks[i].isDone,
            onChanged: (value) => onToggle(i, value),
          ),
      ],
    );
  }
}

class TaskItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const TaskItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('build      $label');
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (newValue) => onChanged(newValue ?? false),
        ),
        Text(label),
      ],
    );
  }
}
```
