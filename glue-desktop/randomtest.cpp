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
    func();

    return 0;
}

// #define int long long
void func() {
    int n;
    cin >> n;
    vector<bool> bits;
    bool firstOneFound = false;
    for (int i = 0; i < n; i++) {
        char tmp;
        cin >> tmp;
        bool bit = tmp == '1';
        if (bit || firstOneFound) {
            bits.push_back(bit);
            firstOneFound = true;
        }
    }
    n = bits.size();

    if (n == 0) {
        cout << "0\n";
        return;
    }

    vector<int> zeroIndexes;
    for (int i = 0; i < n; i++) {
        if (!bits[i]) {
            zeroIndexes.push_back(i);
        }
    }
    if (zeroIndexes.empty() || zeroIndexes[0] >= (n + 1) / 2) {
        for (int i = 0; i < n; i++) {
            cout << "1";
        }
        cout << "\n";
    } else {
        int lowestIndex = zeroIndexes[0];
        for (int i = 0; i < zeroIndexes.size(); i++) {
            zeroIndexes[i] -= lowestIndex;
        }
        vector<bool> bestNum(n - lowestIndex);
        for (int i = 0; i < bestNum.size(); i++) {
            if (bits[i]) bestNum[i] = true;
        }

        for (int i = 1; i < lowestIndex; i++) {
            for (const auto &j : zeroIndexes) {
                if (bestNum[j] != bits[i + j]) {
                    if (!bestNum[j]) {
                        for (int k = 0; k < bestNum.size(); k++) {
                            bestNum[k] = bits[i + k];
                        }
                    }
                    break;
                }
            }
        }

        int x = bits.size() - bestNum.size();
        for (int i = 0; i < bits.size(); i++) {
            bool a = bits[i];
            bool b = i >= x ? bestNum[i - x] : true;
            if (a || b) {
                cout << "1";
            } else {
                cout << "0";
            }
        }
        cout << "\n";
    }
}