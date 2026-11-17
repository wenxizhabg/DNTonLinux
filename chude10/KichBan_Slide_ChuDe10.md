# Kịch bản nói theo slide: Chủ đề 10 (bản 15 phút, 2 người)

Đi kèm `Slide_ChuDe10.tex`. Số slide là số in ở góc dưới phải (trang bìa không đánh số).
Bản đầy đủ, có mốc thời gian của từng video, nằm ở `NoiDung_ChuDe10.md`.

| Người | Slide | Nội dung | Thời lượng |
|---|---|---|---|
| 1 | Bìa đến 10 | App ban đầu, state là gì, bên trong StatefulWidget | 8 phút |
| 2 | 11 đến 17 | Phân loại state, state cục bộ, state cần chia sẻ, prop drilling, bảng so sánh, kết luận | 7 phút |

**Chuẩn bị trước 4 trạng thái code** (mỗi trạng thái một commit Git hoặc một file), không gõ code tại chỗ:

| Ký hiệu | Trạng thái | Dùng ở slide |
|---|---|---|
| C1 | Toàn StatelessWidget, checkbox ghi cứng | 2, 3 |
| C2 | Bản thử sai: `_value` trong StatelessWidget | 4 |
| C3 | `TaskItem` là Stateful, có `initState`, có log trong `build` | 6, 8, 9, 12 |
| C4 | State ở `MyHomePage`, `TaskItem` là Stateless | 13, 14 |

---

## Người 1 (8 phút)

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

### Slide 7. Một StatefulWidget gồm hai class (0:50)

Vì sao cách này chạy được? Một StatefulWidget gồm hai class. Class widget vẫn bất biến, bị thay liên tục, chỉ giữ cấu hình là `label` và có nhiệm vụ tạo ra State. Class State thì thay đổi được, sống qua nhiều lần build, giữ `_value` và chứa hàm `build`. Tờ công thức dùng một lần, in lại bao nhiêu cũng được. Tờ ghi chú của người thợ thì giữ suốt buổi, và đó chính là object State.

### Slide 8. initState và dispose (0:50)

State có hai hàm ở hai đầu vòng đời. `initState` được gọi đúng một lần khi State được tạo, dùng để khởi tạo state từ dữ liệu của widget. Không khởi tạo trong constructor vì lúc đó State chưa gắn với widget. `dispose` được gọi khi State bị gỡ khỏi cây, là chỗ giải phóng controller và timer. Khi đó state cục bộ cũng mất theo. **Chỉ vào console của C3:** 5 dòng `initState`, mỗi `TaskItem` một dòng và chỉ in một lần.

### Slide 9. Vòng đời cập nhật sau setState (1:10)

Sau khi gọi `setState` có 4 bước. Một, hàm truyền vào chạy ngay nên `_value` đổi. Hai, Flutter đánh dấu widget này cần build lại và xin một frame mới. Ba, ở frame kế tiếp, Flutter gọi `build` của đúng các State bị đánh dấu. Bốn, Flutter so cây widget mới với cây cũ, cập nhật phần khác nhau rồi vẽ. **Demo C3:** tick ô "Launch the rocket", console chỉ in một dòng `build` của đúng ô đó. `Progress` và 4 ô còn lại không build lại. `setState` giống việc sửa tờ ghi chú rồi bấm chuông báo bếp làm lại. Sửa mà không bấm chuông thì không ai biết.

### Slide 10. Vòng đời của một State (0:30)

Tổng hợp lại: `createState`, `initState` một lần, rồi `build`. `build` được gọi lại khi State tự gọi `setState`, hoặc khi widget cha build lại và truyền widget mới xuống, lúc đó có `didUpdateWidget`. Cuối cùng là `dispose`. Điểm cần nhớ: widget bị thay nhiều lần, còn object State chỉ được tạo một lần. Phần tiếp theo mời bạn trình bày.

---

## Người 2 (7 phút)

### Slide 11. Phân loại state: ai cần dữ liệu này? (1:00)

Tài liệu Flutter chia state thành hai loại, và chỉ cần một câu hỏi để phân loại: ai cần dữ liệu này? Nếu chỉ một widget cần thì đó là state cục bộ, tiếng Anh là ephemeral state. Nếu một số widget hoặc hầu hết widget cần thì đó là state cần chia sẻ, tức app state. Trong app của nhóm: trạng thái tick nếu chỉ checkbox dùng thì là cục bộ. Khi thanh progress cũng cần nó thì phải chia sẻ.

### Slide 12. Trạng thái cục bộ (1:10)

State cục bộ nằm gọn trong một widget. Các widget khác không cần biết nó thay đổi ra sao. Ví dụ: một menu đang mở hay thu gọn, trang hiện tại của `PageView`, giá trị đang biến đổi của một animation ngắn, chữ đang gõ dở trong ô tìm kiếm. Cách quản lý: StatefulWidget và `setState` là đủ, không cần thư viện nào. Code bên phải là `TaskItem` ở Phần 2: biến `_value` nằm trong State của chính nó. **Chạy C3.** Tick vài ô: checkbox hoạt động, nhưng thanh progress đứng yên, vì `Progress` nằm ở nhánh khác và không đọc được `_value`.

### Slide 13. Trạng thái cần chia sẻ (1:30)

State cần chia sẻ là state mà nhiều widget ở các nhánh khác nhau của cây widget, hoặc nhiều màn hình, cùng đọc và sửa. Ví dụ quen thuộc là giỏ hàng: bấm "Thêm vào giỏ" ở trang sản phẩm thì con số trên AppBar và trang Thanh toán phải cùng cập nhật. Tương tự là thông tin đăng nhập và cài đặt toàn app như giao diện sáng tối hay ngôn ngữ. Trong app của nhóm, trạng thái tick là state cần chia sẻ vì cả checkbox lẫn thanh progress đều cần. Nhóm đưa danh sách `_tasks` lên cha chung là `MyHomePage`, rồi truyền xuống hai nhánh `Progress` và `TaskList`. **Chạy C4.** Tick ô nào thì thanh progress chạy theo ô đó.

### Slide 14. Nếu chỉ dùng setState: prop drilling (1:30)

Cách vừa rồi vẫn chỉ dùng `setState`, và nó có cái giá. Dữ liệu và callback phải truyền lần lượt qua từng cấp widget con. Hiện tượng này gọi là prop drilling. Trong code bên phải, `TaskList` không hề dùng `onToggle`. Nó chỉ nhận từ `MyHomePage` rồi chuyền tiếp cho `TaskItem`. App này mới có một tầng trung gian. Cây càng nhiều tầng thì code càng cồng kềnh và dễ lỗi. Giải pháp là quản lý state tập trung: state đặt ở một nơi, widget nào cần thì lấy trực tiếp. Flutter có sẵn `InheritedWidget`, và các thư viện như Provider, Riverpod, Bloc.

### Slide 15. Bảng so sánh (1:10)

Tổng hợp lại theo bốn tiêu chí. Phạm vi: state cục bộ nằm trong một widget, state cần chia sẻ trải trên nhiều widget, nhiều màn hình. Vòng đời: state cục bộ mất khi widget bị hủy, tức lúc `dispose` ở Phần 3; state cần chia sẻ tồn tại suốt phiên sử dụng app. Công cụ: một bên là StatefulWidget và `setState`, một bên là `InheritedWidget`, Provider, Riverpod, Bloc. Dòng cuối là hai ví dụ trong chính app của nhóm: `_value` của `TaskItem` ở Phần 2, và `_tasks` ở `MyHomePage`.

### Slide 16. Kết luận (0:30)

Bốn ý chính. State là dữ liệu cần để dựng giao diện tại một thời điểm. Widget bất biến, nên StatefulWidget tách thành hai class. Vòng đời State gồm `initState` một lần, `build` nhiều lần, `setState` để yêu cầu build lại, `dispose` khi bị gỡ. State cục bộ để trong một widget và dùng `setState`; state cần chia sẻ nếu chỉ dùng `setState` sẽ gặp prop drilling, nên cần giải pháp quản lý tập trung.

### Slide 17. Tài liệu tham khảo (0:10)

Bài trình bày dựa trên 4 video của kênh Flutter và tài liệu Flutter. Nhóm em xin cảm ơn thầy cô và các bạn đã lắng nghe.
