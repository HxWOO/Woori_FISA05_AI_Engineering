# 첫째 줄에 N, M, B가 주어진다. (1 ≤ M, N ≤ 500, 0 ≤ B ≤ 6.4 × 107)
# 둘째 줄부터 N개의 줄에 각각 M개의 정수로 땅의 높이가 주어진다. 
# (i + 2)번째 줄의 (j + 1)번째 수는 좌표 (i, j)에서의 땅의 높이를 나타낸다. 
# 땅의 높이는 256보다 작거나 같은 자연수 또는 0이다.

# 첫째 줄에 땅을 고르는 데 걸리는 시간과 땅의 높이를 출력하시오. 답이 여러 개 있다면 그중에서 땅의 높이가 가장 높은 것을 출력한다

# --- 기존 코드 (시간 초과 발생) ---
# 원인: 목표 높이(height)를 0부터 256까지 순회하는 루프 안에서,
#      땅 전체(N*M)를 다시 순회하는 중첩 루프 구조로 인해
#      전체 연산량이 (257 * N * M)에 가까워져 시간 초과 발생.

# import sys
# 
# n, m, b = map(int, sys.stdin.readline().split())
# land = [list(map(int, sys.stdin.readline().split())) for _ in range(n)]
# answer_t = 1e8
# answer_h = 0
# 
# for height in range(257):
#     time = 0
#     used_block = 0
# 
#     for i in range(n):
#         for j in range(m):
#             if land[i][j] > height:
#                 time += 2 * (land[i][j] - height)
#                 used_block -= (land[i][j] - height)
#             
#             if land[i][j] == height:
#                 continue
#             else:
#                 time += ((height - land[i][j]))
#                 used_block += ((height - land[i][j]))
#     
#     if time <= answer_t and used_block<=b:
#         answer_t = time
#         answer_h = height
# 
# print(answer_t, answer_h)


# --- 수정된 코드 (최적화 적용) ---
import sys
# collections.Counter: 리스트 안의 요소들의 개수를 딕셔너리 형태로 세어주는 효율적인 도구
from collections import Counter

n, m, b = map(int, sys.stdin.readline().split())

# 개선점 1: 땅의 높이 정보를 2차원 리스트가 아닌 1차원 리스트로 받기
# 어차피 모든 땅을 순회하며 높이 정보만 필요하므로, 2차원으로 관리할 필요가 없음.
# extend를 사용해 메모리를 더 효율적으로 사용.
land_list = []
for _ in range(n):
    land_list.extend(list(map(int, sys.stdin.readline().split())))

# 개선점 2: 땅 높이의 분포를 미리 계산 (핵심 최적화)
# Counter를 사용해 각 높이에 해당하는 땅이 몇 개씩 있는지 미리 계산함.
# 예: {64: 15, 0: 10} -> 높이가 64인 땅 15개, 높이가 0인 땅 10개
# 이렇게 하면 N*M 크기의 땅을 매번 순회할 필요 없이, 높이의 종류(최대 257개)만큼만 순회하면 됨.
land_counts = Counter(land_list)

# 개선점 3: 불필요한 높이 탐색 제거
# 땅을 고르는 최적의 높이는 현재 땅의 최소 높이와 최대 높이 사이에 반드시 존재함.
# 따라서 0부터 256까지 모두 확인할 필요 없이, 실제 땅의 min/max 높이 범위만 탐색하여 연산량 감소.
min_h = min(land_counts)
max_h = max(land_counts)

# 정답 변수 초기화. 시간은 무한대(inf)로 설정하여 첫 번째 유효한 시간을 바로 저장하도록 함.
answer_t = float('inf')
answer_h = 0

# 가능한 높이(최소 ~ 최대)만 순회
for height in range(min_h, max_h + 1):
    time = 0
    inventory = b # 현재 인벤토리에 있는 블록 수

    # 개선점 4: N*M 루프를 높이 종류 루프로 대체
    # 기존 코드의 이중 for문을 제거하고, 미리 계산한 land_counts를 순회.
    # 이 루프는 땅의 높이 종류만큼만 반복하므로 최대 257번만 실행됨.
    for h, count in land_counts.items():
        if h > height: # 현재 땅의 높이가 목표 높이보다 높을 때 (블록 제거)
            diff = h - height
            time += diff * 2 * count # (높이 차) * (2초) * (해당 높이의 땅 개수)
            inventory += diff * count    # 제거한 블록을 인벤토리에 추가
        
        elif h < height: # 현재 땅의 높이가 목표 높이보다 낮을 때 (블록 쌓기)
            diff = height - h
            time += diff * 1 * count # (높이 차) * (1초) * (해당 높이의 땅 개수)
            inventory -= diff * count    # 인벤토리에서 블록 사용

    # 모든 땅을 순회한 후, 사용한 블록의 수가 적절한지 확인
    if inventory >= 0:
        # 현재까지 계산된 시간이 최소 시간이거나, 최소 시간과 같을 경우
        # (시간이 같을 경우 높이가 더 높은 것을 선택해야 하므로 <= 사용)
        if time <= answer_t:
            answer_t = time
            answer_h = height

print(answer_t, answer_h)
