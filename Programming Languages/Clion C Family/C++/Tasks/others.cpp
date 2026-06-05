// void* ptr = 0;
    /*
    size_t size = -4096;

    int* p = (int*)mmap(
        nullptr,
        size,
        PROT_READ | PROT_WRITE,
        MAP_PRIVATE | MAP_ANONYMOUS,
        -1,
        0
    );
    p[0] = 42;
    cout << p << endl;
    munmap(p, size);
    */
    /*
    int* addr = (int*) 0x1111111;
    mprotect(addr, 4096, PROT_READ);
    ((int*)addr)[0] = 5;
    */
    /*
    size_t size = 4096;

    int* p = (int*)mmap(
        0x0,
        size,
        PROT_READ | PROT_WRITE,
        MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
        -1,
        0
    );
    *p = 10;
    */
    /*
    
    void* addr = mmap(
        (void*)-0x1,
        4096,
        PROT_READ | PROT_WRITE,
        MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED,
        -1,
        0
    );

    std::cout << "Returned: " << addr << '\n';

    if (addr == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }

    ((int*)addr)[0] = 10;
    */
/*
    string s = "saisakthi";
    printf("%s", s.c_str());
    log(1);
    bool a = -1;

    printf("%s", (char*) a);
    story('a');
     std::cout << "hello world" << std::endl;

    unsigned int x = 10;

    unsigned int* y = (unsigned int*) x;
    cout << x << endl;
    cout << x << endl;
    cout << sizeof(float) << endl;
    cout << multiply(1, -1) << endl;

    int* arr = new int[500];
    free(arr);
    arr[0] = 1.3;
    cout << arr << endl;
    */