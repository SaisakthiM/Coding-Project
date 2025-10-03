from setuptools import find_packages, setup

setup(
    name='django_ai',
    version='0.1.0',
    description='Interactive Django AI project with notebook integration',
    author='Your Name',
    author_email='your@email.com',
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        # These should ideally match your requirements.txt
        'Django>=3.2',
        'djangorestframework',
        'jupyter',
        'ipython',
        'pandas',
        'numpy',
        'openai',
        'transformers',
    ],
    classifiers=[
        'Framework :: Django',
        'Programming Language :: Python :: 3',
    ],
)
