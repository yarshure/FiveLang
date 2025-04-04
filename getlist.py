import requests

def get_top_github_repos(category, count=10):
    """
    获取 GitHub 上指定类别 star 数最多的仓库列表。

    Args:
        category (str): 要搜索的仓库类别 (例如: 'ai', 'game', 'python').
        count (int): 要获取的仓库数量 (默认为 10).

    Returns:
        list: 包含仓库信息的字典列表 (name, stars, url)，如果出错则返回 None.
              每个字典包含: 'name', 'stars', 'url'.
        str: 如果发生错误，返回错误信息字符串。
    """
    # GitHub API 搜索仓库的 URL
    # 使用 'topic:' 限定符按主题搜索
    # sort=stars 按 star 数量排序
    # order=desc 按降序排序 (最多的在前)
    # per_page=count 指定返回数量
    api_url = f"https://api.github.com/search/repositories"
    query_params = {
        'q': f'topic:{category}',
        'sort': 'stars',
        'order': 'desc',
        'per_page': count
    }
    headers = {
        'Accept': 'application/vnd.github.v3+json' # 推荐使用的 API 版本
    }

    try:
        print(f"正在为类别 '{category}' 获取 GitHub 仓库信息...")
        response = requests.get(api_url, params=query_params, headers=headers, timeout=15)
        # 检查请求是否成功
        response.raise_for_status() # 如果状态码不是 2xx，会抛出 HTTPError 异常

        data = response.json()

        # 检查 'items' 键是否存在且不为空
        if 'items' not in data or not data['items']:
            return [], f"未能找到类别为 '{category}' 的仓库，或者该类别下没有仓库。"

        repos_info = []
        for repo in data['items']:
            repos_info.append({
                'name': repo['full_name'],       # 仓库全名 (owner/repo_name)
                'stars': repo['stargazers_count'], # Star 数量
                'url': repo['html_url']          # 仓库的 GitHub URL
            })

        return repos_info, None # 返回仓库列表和 None (表示无错误)

    except requests.exceptions.Timeout:
        return None, "请求 GitHub API 超时。"
    except requests.exceptions.HTTPError as http_err:
        # 处理常见的 GitHub API 错误
        if response.status_code == 403:
             # 检查是否是速率限制问题
            rate_limit_remaining = response.headers.get('X-RateLimit-Remaining')
            if rate_limit_remaining == '0':
                return None, f"GitHub API 速率限制。请稍后再试或使用 API Token 认证。"
            else:
                return None, f"访问 GitHub API 时发生 HTTP 错误: {http_err} (可能是权限问题)"
        elif response.status_code == 422:
             return None, f"请求参数无效或验证失败: {http_err}. 请检查输入的类别是否有效。"
        else:
            return None, f"访问 GitHub API 时发生 HTTP 错误: {http_err}"
    except requests.exceptions.RequestException as req_err:
        return None, f"访问 GitHub API 时发生网络或其他请求错误: {req_err}"
    except Exception as e:
        return None, f"处理数据时发生未知错误: {e}"


if __name__ == "__main__":
    try:
        # 获取用户输入的类别
        category_input = input("请输入你想搜索的 GitHub 仓库类别 (例如: ai, game, javascript): ")

        if not category_input:
            print("错误：类别不能为空。")
        else:
            # 调用函数获取数据
            top_repos, error_message = get_top_github_repos(category_input, count=10)

            if error_message:
                print(f"错误: {error_message}")
            elif top_repos:
                print(f"\n--- 类别 '{category_input}' Star 数最多的前 {len(top_repos)} 个仓库 ---")
                # 打印结果
                for i, repo in enumerate(top_repos):
                    # 使用 f-string 进行格式化，让星数右对齐
                    print(f"{i+1}. {repo['name']} - Stars: {repo['stars']:<8} - URL: {repo['url']}")
            else:
                 # 这个分支理论上应该被 error_message 覆盖，但为了完整性保留
                print(f"未能找到类别为 '{category_input}' 的仓库。")

    except KeyboardInterrupt:
        print("\n操作被用户中断。")