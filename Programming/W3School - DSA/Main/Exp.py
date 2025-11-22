from typing import List


class Solution:
    def topKFrequent(self, nums: List[int], k: int):
        p = list(set(nums))
        count_res = [nums.count(x) for x in p]
        res = []
        if len(set(count_res)) == 1:
            for x in range(k):
                res.append(p[x])
            return res
        else:
            for x in range(k):
                res.append(p[count_res.index(max(count_res))])
                count_res.remove(max(count_res))
                return count_res

o = Solution()
print(o.topKFrequent([1,1,1,2,2,2,3,3,3],2))

        