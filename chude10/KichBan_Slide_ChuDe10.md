# Kịch bản nói theo slide: Chủ đề 10 (bản 15 phút, 2 người)

Đi kèm `Slide_ChuDe10.tex`. Số slide là số in ở góc dưới phải (trang bìa không đánh số).
Bản đầy đủ, có mốc thời gian của từng video, nằm ở `NoiDung_ChuDe10.md`.

| Người | Slide | Nội dung | Thời lượng |
|---|---|---|---|
| 1 | Bìa đến 11 | App ban đầu, state là gì, vòng đời của State | 8,5 phút |
| 2 | 12 đến 18 | Phân loại state, state cục bộ, state cần chia sẻ, prop drilling, bảng so sánh, kết luận | 7 phút |

**Chuẩn bị trước 4 trạng thái code** (mỗi trạng thái một commit Git hoặc một file), không gõ code tại chỗ:

| Ký hiệu | Trạng thái | Dùng ở slide |
|---|---|---|
| C1 | Toàn StatelessWidget, checkbox ghi cứng | 2, 3 |
| C2 | Bản thử sai: `_value` trong StatelessWidget | 4 |
| C3 | `TaskItem` là Stateful, có `initState`, có log trong `build` | 6, 8, 10, 13 |
| C4 | State ở `MyHomePage`, `TaskItem` là Stateless | 14, 15 |

---

## Người 1 (8,5 phút)

### Bìa và slide 1. Nội dung (0:30)

Nhóm em trình bày Chủ đề 10: cơ sở quản lý trạng thái và cập nhật giao diện trong Flutter. Bài gồm 4 phần và dùng một app duy nhất tên là Space exploration. Mỗi phần sửa tiếp code của phần trước.

### Slide 2. App ban đầu: toàn StatelessWidget (0:40)

**Chạy C1.** App gồm thanh tiến độ và danh sách việc cần làm. Cây widget ở bên trái: `MyHomePage` chứa `Progress` và `TaskList`, `TaskList` chứa 5 `TaskItem`. Tất cả đều là StatelessWidget. Bấm vào checkbox thì không có gì xảy ra. Hai dòng màu đỏ trong code cho thấy `value` và `onChanged` đang được ghi cứng. Câu hỏi của bài: vì sao không tick được, và "state" trong chữ stateless là gì?

### Slide 3. Widget không bao giờ thay đổi (0:50)

Tài liệu Flutter định nghĩa widget là bản mô tả một phần giao diện, và bản mô tả đó bất biến. Trong code, field là `final`, constructor là `const`. Có thể hình dung widget như tờ công thức làm bánh: khi làm, ta theo đúng từng bước và không sửa công thức. Giao diện hiện tại đang chạy đúng mô tả: luôn `false`, bấm vào không làm gì. Vấn đề là giao diện phải đổi theo thao tác của người dùng, còn widget thì không đổi. Vậy dữ liệu thay đổi để ở đâu?

### Slide 4. Thử sửa: đưa value vào một biến (0:50)

**Chạy C2.** Cách dễ nghĩ tới nhất là thêm biến `_value` và gán lại trong `onChanged`. Kết quả: checkbox vẫn không tick. Trình soạn thảo còn cảnh báo class bất biến mà có field không `final`. Nguyên nhân là `_value` có đổi, nhưng không ai gọi lại hàm `build`, nên màn hình vẫn là kết quả của lần build trước. Giống như sửa tờ công thức sau khi bánh đã ra lò.

### Slide 5. State và mối quan hệ với giao diện (0:50)

Phần dữ liệu thay đổi đó gọi là state. State là mọi dữ liệu cần có để dựng giao diện tại một thời điểm. Với `TaskItem`, state là một giá trị bool. Quan hệ giữa hai bên viết gọn là UI bằng build của state. Ta không ra lệnh "tick ô này". Ta đổi state, hàm `build` chạy lại và trả về giao diện mới. Ví dụ với chiếc bánh: có báo "bánh sắp hết" hay không phụ thuộc vào số lát đã bị lấy, không nằm trong công thức.

### Slide 6. Chuyển sang StatefulWidget và gọi setState (1:00)

`TaskItem` cần state nên phải là StatefulWidget. Trong VS Code, bấm `Ctrl + .` rồi chọn Convert to StatefulWidget. Biến `_value` và hàm `build` chuyển sang class State, nhãn được đọc qua `widget.label`. Phần phải tự thêm là `setState`: ta đổi state bên trong hàm truyền cho `setState` để báo Flutter rằng state đã đổi. **Chạy C3.** Checkbox tick được.

### Slide 7. Vòng đời của State: ba giai đoạn (0:40)

Vì sao cách này chạy được? Vì `_value` nằm trong object State, và object này có vòng đời riêng gồm ba giai đoạn: khởi tạo, cập nhật, giải phóng. Thứ tự đầy đủ là `createState`, `initState`, `didChangeDependencies`, rồi `build`. `build` lặp lại nhiều lần mỗi khi có `setState` hoặc `didUpdateWidget`. Cuối cùng là `deactivate` và `dispose`. Điểm cần nhớ: widget bị thay nhiều lần, còn object State chỉ được tạo một lần và sống qua mọi lần build.

### Slide 8. Giai đoạn khởi tạo (0:50)

Giai đoạn một có ba hàm. `createState` được framework gọi đầu tiên để tạo object State gắn với StatefulWidget. `initState` được gọi đúng một lần khi State vừa được gắn vào cây, dùng để khởi tạo biến, đăng ký listener, stream, timer. `didChangeDependencies` được gọi ngay sau `initState`, và gọi lại khi thứ mà widget phụ thuộc thay đổi, ví dụ `Theme.of(context)`. Code bên phải là `TaskItem` của app: `initState` lấy giá trị ban đầu từ `widget.initialValue`. **Chỉ vào console của C3:** 5 dòng `initState`, mỗi `TaskItem` một dòng và chỉ in một lần.

### Slide 9. Giai đoạn cập nhật: build và didUpdateWidget (0:40)

Giai đoạn hai là giai đoạn lặp lại. `build` trả về cây widget ứng với state hiện tại. Nó được gọi nhiều lần: sau `didChangeDependencies`, sau mỗi lần `setState`, và khi widget cha dựng lại. `didUpdateWidget` được gọi khi widget cha dựng lại và truyền cấu hình mới xuống; lúc đó object State bên dưới vẫn được giữ nguyên. Code bên phải là hàm `build` của `_TaskItemState`: đọc `_value` để vẽ checkbox, và gọi `setState` khi người dùng bấm.

### Slide 10. Giai đoạn cập nhật: sau khi gọi setState (1:00)

Sau khi gọi `setState` có 4 bước. Một, hàm truyền vào chạy ngay nên `_value` đổi. Hai, Flutter đánh dấu widget này cần build lại và xin một frame mới. Ba, ở frame kế tiếp, Flutter gọi `build` của đúng các State bị đánh dấu. Bốn, Flutter so cây widget mới với cây cũ, cập nhật phần khác nhau rồi vẽ. **Demo C3:** tick ô "Launch the rocket", console chỉ in một dòng `build` của đúng ô đó. `Progress` và 4 ô còn lại không build lại.

### Slide 11. Giai đoạn giải phóng (0:40)

Giai đoạn ba có hai hàm. `deactivate` được gọi khi State bị tháo khỏi cây widget; State vẫn có thể được gắn lại ở vị trí khác, ví dụ khi dùng `GlobalKey`. `dispose` được gọi đúng một lần khi State bị gỡ vĩnh viễn, ví dụ khi đóng màn hình. Ở đây bắt buộc phải hủy controller, timer, stream để tránh rò rỉ bộ nhớ. `TaskItem` của app chưa giữ tài nguyên nào nên `dispose` chỉ in log. Sau `dispose`, state cục bộ mất theo. Phần tiếp theo mời bạn trình bày.

---

## Người 2 (7 phút)

### Slide 12. Phân loại state: ai cần dữ liệu này? (1:00)

Tài liệu Flutter chia state thành hai loại, và chỉ cần một câu hỏi để phân loại: ai cần dữ liệu này? Nếu chỉ một widget cần thì đó là state cục bộ, tiếng Anh là ephemeral state. Nếu một số widget hoặc hầu hết widget cần thì đó là state cần chia sẻ, tức app state. Trong app của nhóm: trạng thái tick nếu chỉ checkbox dùng thì là cục bộ. Khi thanh progress cũng cần nó thì phải chia sẻ.

### Slide 13. Trạng thái cục bộ (1:10)

State cục bộ nằm gọn trong một widget. Các widget khác không cần biết nó thay đổi ra sao. Ví dụ: một menu đang mở hay thu gọn, trang hiện tại của `PageView`, giá trị đang biến đổi của một animation ngắn, chữ đang gõ dở trong ô tìm kiếm. Cách quản lý: StatefulWidget và `setState` là đủ, không cần thư viện nào. Code bên phải là `TaskItem` ở Phần 2: biến `_value` nằm trong State của chính nó. **Chạy C3.** Tick vài ô: checkbox hoạt động, nhưng thanh progress đứng yên, vì `Progress` nằm ở nhánh khác và không đọc được `_value`.

### Slide 14. Trạng thái cần chia sẻ (1:30)

State cần chia sẻ là state mà nhiều widget ở các nhánh khác nhau của cây widget, hoặc nhiều màn hình, cùng đọc và sửa. Ví dụ quen thuộc là giỏ hàng: bấm "Thêm vào giỏ" ở trang sản phẩm thì con số trên AppBar và trang Thanh toán phải cùng cập nhật. Tương tự là thông tin đăng nhập và cài đặt toàn app như giao diện sáng tối hay ngôn ngữ. Trong app của nhóm, trạng thái tick là state cần chia sẻ vì cả checkbox lẫn thanh progress đều cần. Nhóm đưa danh sách `_tasks` lên cha chung là `MyHomePage`, rồi truyền xuống hai nhánh `Progress` và `TaskList`. **Chạy C4.** Tick ô nào thì thanh progress chạy theo ô đó.

### Slide 15. Nếu chỉ dùng setState: prop drilling (1:30)

Cách vừa rồi vẫn chỉ dùng `setState`, và nó có cái giá. Dữ liệu và callback phải truyền lần lượt qua từng cấp widget con. Hiện tượng này gọi là prop drilling. Trong code bên phải, `TaskList` không hề dùng `onToggle`. Nó chỉ nhận từ `MyHomePage` rồi chuyền tiếp cho `TaskItem`. App này mới có một tầng trung gian. Cây càng nhiều tầng thì code càng cồng kềnh và dễ lỗi. Giải pháp là quản lý state tập trung: state đặt ở một nơi, widget nào cần thì lấy trực tiếp. Flutter có sẵn `InheritedWidget`, và các thư viện như Provider, Riverpod, Bloc.

### Slide 16. Bảng so sánh (1:10)

Tổng hợp lại theo bốn tiêu chí. Phạm vi: state cục bộ nằm trong một widget, state cần chia sẻ trải trên nhiều widget, nhiều màn hình. Vòng đời: state cục bộ mất khi widget bị hủy, tức lúc `dispose` ở Phần 3; state cần chia sẻ tồn tại suốt phiên sử dụng app. Công cụ: một bên là StatefulWidget và `setState`, một bên là `InheritedWidget`, Provider, Riverpod, Bloc. Dòng cuối là hai ví dụ trong chính app của nhóm: `_value` của `TaskItem` ở Phần 2, và `_tasks` ở `MyHomePage`.

### Slide 17. Kết luận (0:30)

Bốn ý chính. State là dữ liệu cần để dựng giao diện tại một thời điểm. Widget bất biến, nên StatefulWidget tách thành hai class. Vòng đời State có ba giai đoạn: khởi tạo với `initState` một lần, cập nhật với `build` nhiều lần sau mỗi `setState`, giải phóng với `dispose` một lần. State cục bộ để trong một widget và dùng `setState`; state cần chia sẻ nếu chỉ dùng `setState` sẽ gặp prop drilling, nên cần giải pháp quản lý tập trung.

### Slide 18. Tài liệu tham khảo (0:10)

Bài trình bày dựa trên 4 video của kênh Flutter và tài liệu Flutter. Nhóm em xin cảm ơn thầy cô và các bạn đã lắng nghe.
