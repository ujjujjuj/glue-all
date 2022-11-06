#include <bits/stdc++.h>

using namespace std;

void func();

template <class T>
void print_v(vector<T> &v) {
    cout << "[ ";
    for (const auto &x : v) cout << x << " ";
    cout << "]" << endl;
}

int main() {
    ios_base::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    int t;
    cin >> t;
    while (t--) {
        func();
    }

    return 0;
}

// #define int long long
void func() {
    int n;
    cin >> n;
    cout << 1 << " ";
    for (int i = n ; i > 1; i--) {
        cout << i << " ";
    }
    cout << "\n";
}