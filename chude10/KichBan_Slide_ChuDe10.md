# Kịch bản nói theo slide: Chủ đề 10 (bản 15 phút, 2 người)

Đi kèm `Slide_ChuDe10.tex`. Số slide là số in ở góc dưới phải (trang bìa không đánh số).
Bản đầy đủ, có mốc thời gian của từng video, nằm ở `NoiDung_ChuDe10.md`.

| Người | Slide | Nội dung | Thời lượng |
|---|---|---|---|
| 1 | Bìa đến 10 | App ban đầu, state là gì, bên trong StatefulWidget | 8 phút |
| 2 | 11 đến 17 | State cục bộ và chia sẻ, đưa state lên cha, giới hạn, kết luận | 7 phút |

**Chuẩn bị trước 4 trạng thái code** (mỗi trạng thái một commit Git hoặc một file), không gõ code tại chỗ:

| Ký hiệu | Trạng thái | Dùng ở slide |
|---|---|---|
| C1 | Toàn StatelessWidget, checkbox ghi cứng | 2, 3 |
| C2 | Bản thử sai: `_value` trong StatelessWidget | 4 |
| C3 | `TaskItem` là Stateful, có `initState`, có log trong `build` | 6, 8, 9 |
| C4 | State ở `MyHomePage`, `TaskItem` là Stateless, có log | 13, 14, 15 |

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

### Slide 11. Vấn đề: thanh progress đứng yên (1:00)

**Chạy C3.** Tick vài ô: checkbox hoạt động nhưng thanh progress không nhúc nhích. Nhìn code sẽ thấy lý do. `Progress` đang ghi cứng `value: 0.0`. State của mỗi checkbox nằm riêng trong từng `_TaskItemState`, là biến private. Trên cây widget, `Progress` nằm ở nhánh khác nên không đọc được.

### Slide 12. State cục bộ và state cần chia sẻ (1:00)

Có hai loại state. State cục bộ chỉ một widget cần, ví dụ tab đang chọn hay nội dung đang gõ. Loại này để trong State của chính widget đó và dùng `setState` là đủ. State cần chia sẻ là state mà từ hai widget trở lên cùng cần. Ở đây trạng thái tick vừa quyết định checkbox, vừa quyết định thanh progress. Câu hỏi để phân loại: ai cần đọc dữ liệu này? Quản lý state có hai mục tiêu: cho các widget truy cập được dữ liệu, và báo cho widget build lại khi dữ liệu đổi.

### Slide 13. Đưa state lên widget cha chung (1:30)

Cách cơ sở nhất là đưa state lên widget cha chung gần nhất của `Progress` và `TaskList`, tức là `MyHomePage`. `MyHomePage` trở thành StatefulWidget, giữ danh sách `_tasks` và hàm `_toggle` có gọi `setState`. Trong `build`, nó đếm số việc đã xong rồi truyền xuống hai con. Dữ liệu đi xuống qua tham số constructor. Sự kiện đi lên qua callback `onToggle`. Giống như cả bếp dùng một tấm bảng chung treo ở chỗ bếp trưởng: thợ xong việc thì báo bếp trưởng ghi lên bảng.

### Slide 14. TaskItem không còn giữ state (1:20)

Trạng thái tick đã nằm ở cha, nên `TaskItem` không cần State nữa và trở lại StatelessWidget. Nó hiển thị `value` nhận từ cha, và khi bị bấm thì gọi `onChanged` để cha tự đổi state. Như vậy mỗi dữ liệu chỉ có một nơi giữ. **Chạy C4.** Tick ô nào thì thanh progress chạy theo ô đó.

### Slide 15. Giới hạn của cách quản lý state bằng setState (1:30)

**Demo C4:** xóa console, tick đúng một ô. Console in 8 dòng: cả `MyHomePage`, `Progress`, `TaskList` và 5 `TaskItem` đều build lại. Ở Phần 3, tick một ô chỉ build lại một `TaskItem`. Từ đây có ba giới hạn. Một, phạm vi build lại rộng: state càng lên cao, một thay đổi nhỏ càng kéo nhiều widget build lại. Hai, phải chuyền dữ liệu qua từng tầng: `TaskList` không dùng `onToggle` nhưng vẫn phải nhận rồi chuyền tiếp. Ba, state gắn với vị trí trong cây: widget bị gỡ thì state mất, và nếu màn hình khác cần dùng thì phải đưa lên cao hơn nữa. Hướng tiếp theo là đặt state ngoài cây widget, widget nào cần thì theo dõi, như Provider hay Riverpod.

### Slide 16. Kết luận (0:30)

Bốn ý chính. State là dữ liệu cần để dựng giao diện tại một thời điểm. Widget bất biến, nên StatefulWidget tách thành hai class. Vòng đời State gồm `initState` một lần, `build` nhiều lần, `setState` để yêu cầu build lại, `dispose` khi bị gỡ. State cục bộ để trong widget, state cần chia sẻ đưa lên cha chung, và cách này có giới hạn khi app lớn dần.

### Slide 17. Tài liệu tham khảo (0:10)

Bài trình bày dựa trên 4 video của kênh Flutter. Nhóm em xin cảm ơn thầy cô và các bạn đã lắng nghe.
