优化概述

修改一：//src/opt/pass/live.cpp
void LivenessAnalysisPass::_init_live_use_def(ir::Block &block)
在每次检查是否存在于 `live_def` 或 `live_use` 集合时，使用 `find` 函数会多次遍历集合。我们可以用局部变量减少调用次数，提高优化速度。使用 `std::dynamic_pointer_cast` 多次进行类型转换可能会影响性能，甚至可能导致堆栈上的临时对象创建。可以考虑在此之前直接检查类型将不同部分的逻辑封装为单独的辅助函数，可提高代码的可读性和可维护性


修改二：//src/opt/pass/simplify_cfg.cpp
bool EmptyBlockRemovalPass::run_on_function(ir::Function &func)
简化块替换逻辑: 通过标记和批量处理空块而不是一一替换，提高性能。在一次遍历中收集空块，并在最后进行统一的替换或删除，这样可以避免多次冗余计算。


修改三：//src/opt/pass/simplify_cfg.cpp
std::unordered_set<ir::BlockPtr> UnreachableBlockRemovalPass::_find_reachable_blocks(const ir::Function &func)
**图标遍历的改进**: 可以使用 BFS（广度优先搜索）替代 DFS（深度优先搜索），这样可以更好地处理当图非常深时可能导致的栈溢出。使用一个队列来保持可达的块，也可以避免重复访问。



修改四：src/vistor.cpp

在visit_binary_exp 函数中，使用了一些常见的编译器优化方法来提高代码执行效率。
以下是这些优化方法及其作用的描述：

1.常量折叠（Constant Folding）：

对于加法（ADD）操作，如果左操作数或右操作数是常量0，则直接返回另一个操作数。
对于减法（SUB）操作，如果右操作数是常量0，则直接返回左操作数。
对于乘法（MULT）操作，如果左操作数是常量1，则直接返回右操作数；如果左操作数是常量0，则直接返回左操作数。同样地，如果右操作数是常量1，则直接返回左操作数；如果右操作数是常量0，则直接返回右操作数。
对于除法（DIV）操作，如果右操作数是常量1，则直接返回左操作数。
这些优化通过在编译时识别并处理常量表达式，减少了运行时的计算量，从而提高了执行效率。

2.类型转换优化（Type Conversion Optimization）：

在进行二元操作之前，函数会检查左右操作数的类型，并进行必要的类型转换（_convert_if_needed）。如果类型不匹配，则返回错误类型。通过这种方式，确保了操作数在进行二元操作时具有相同的类型，避免了运行时的类型错误。

3.类型检查（Type Checking）：

在进行模运算（MOD）时，函数会检查操作数的类型是否为 int32。如果不是，则返回错误类型并报告错误。
这种类型检查可以防止不合法的操作，提高代码的健壮性。