# =========================
#  构建阶段（builder）
# =========================
FROM python:3.12 AS builder

# 设置工作目录
WORKDIR /app

# 安装 uv（现代依赖管理工具）
RUN pip install uv

# 拷贝配置文件
COPY pyproject.toml ./

# 创建虚拟环境并安装依赖
RUN uv venv .venv
RUN uv pip compile pyproject.toml -o requirements.txt && \
    uv pip install --python .venv/bin/python -r requirements.txt

# 拷贝项目源码和测试
COPY . .

# =========================
#  最终运行阶段
# =========================
FROM python:3.12-slim

WORKDIR /app

# 从构建阶段复制虚拟环境
COPY --from=builder /app/.venv /app/.venv

# 必须复制 tests 目录（老师公告要求）
COPY --from=builder /app/tests ./tests

# 复制源代码
COPY --from=builder /app/cc_simple_server ./cc_simple_server

# 设置环境变量（保证虚拟环境里的包可用）
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONPATH=/app

# 启动 FastAPI 应用
CMD ["uvicorn", "cc_simple_server.server:app", "--host", "0.0.0.0", "--port", "8000"]
